require_dependency "mjbook/application_controller"

module Mjbook
  class ExpendsController < ApplicationController
    before_action :set_expend, only: [:show, :edit, :update, :destroy, :reconcile, :unreconcile]
    before_action :set_accounts, only: [:edit, :pay_employee, :pay_business, :pay_salary]
    before_action :set_paymethods, only: [:edit, :pay_employee, :pay_business, :pay_salary]

    # GET /expends
    def index
    if params[:hmrcexpcat_id]

        if params[:hmrcexpcat_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @expends = policy_scope(Expend).joins(:expense).where('mjbook_expenses.hmrcexpcat_id =?', params[:hmrcexpcat_id]).where(:date => params[:date_from]..params[:date_to])
            else
              @expends = policy_scope(Expend).joins(:expense).where('mjbook_expenses.hmrcexpcat_id =?', params[:hmrcexpcat_id]).where('date > ?', params[:date_from])
            end
          else
            if params[:date_to] != ""
              @expends = policy_scope(Expend).joins(:expense).where('mjbook_expenses.hmrcexpcat_id =?', params[:hmrcexpcat_id]).where('date < ?', params[:date_to])
            else
              @expends = policy_scope(Expend).joins(:expense).where('mjbook_expenses.hmrcexpcat_id =?', params[:hmrcexpcat_id])
            end
          end
        else
          if params[:date_from] != ""
            if params[:date_to] != ""
              @expends = policy_scope(Expend).where(:date => params[:date_from]..params[:date_to])
            else
              @expends = policy_scope(Expend).where('date > ?', params[:date_from])
            end
          else
            if params[:date_to] != ""
              @expends = policy_scope(Expend).where('date < ?', params[:date_to])
            else
              @expends = policy_scope(Expend)
            end
          end
        end

     else
       @expends = policy_scope(Expend)
     end

     if params[:commit] == 'pdf'
       pdf_expend_index(@expends, params[:hmrcexpcat_id], params[:date_from], params[:date_to])
     end

     if params[:commit] == 'csv'
       csv_expend_index(@expends, params[:hmrcexpcat_id])
     end



     @sum_price = @expends.sum(:price)
     @sum_vat = @expends.sum(:vat)
     @sum_total = @expends.sum(:total)

     #selected parameters for filter form
     hmrcexpcats_ids = policy_scope(Expense).joins(:expenditems => :expend).where('mjbook_expends.company_id =?', current_user.company_id).pluck(:hmrcexpcat_id).uniq
     @hmrcexpcats = policy_scope(Hmrcexpcat).where(:id => hmrcexpcats_ids)
     @hmrcexpcat = params[:hmrcexpcat_id]
     @date_from = params[:date_from]
     @date_to = params[:date_to]

     @check_expend_exist = policy_scope(Expend).first

     authorize @expends
    end

    # GET /expends/1
    def show
      authorize @expend
      @expenditems = Mjbook::Expenditem.where(:expend_id => @expend.id)
    end

    # GET /expends/new
    def new
      
      if params[:expense_id]
         @expense_id = params[:expense_id]
      end

      @expend = Expend.new
      @expenses = Mjbook::Expense.accepted.joins(:project).where('mjbook_projects.company_id' => current_user.company_id).business

    end

    # GET /expends/new

    def pay_employee

      expenses = Mjbook::Expense.accepted.where(:exp_type => 1, :user_id => params[:id])
      user = User.where(:id => params[:id]).first

      @expenses = {}
      @expenses[:employee_id] = user.id
      @expenses[:employee_name] = user.name
      @expenses[:price] = expenses.sum(:price)
      @expenses[:vat] = expenses.sum(:vat)
      @expenses[:total] = expenses.sum(:total)

      @expend = Expend.new

    end

    def pay_business
      @expense = Mjbook::Expense.where(:id => params[:id]).first
      @expend = Expend.new
    end

    def pay_salary
      @salary = Mjbook::Salary.where(:id => params[:id]).first
      @expend = Expend.new
    end

    # GET /expends/1/edit
    def edit
      authorize @expend
    end

    # POST /expends
    def create
      @expend = Expend.new(expend_params)
      authorize @expend
      if @expend.save

        if @expend.business?
          expense = Mjbook::Expense.where(:id => params[:expense_id]).first
          Mjbook::Expenditem.create(:expend_id => @expend.id, :expense_id => expense.id)
          expense.pay!
        end

        if @expend.personal?
          expenses = Mjbook::Expense.accepted.where(:exp_type => 1, :user_id => params[:employee_id])
          expenses.each do |item|
            Mjbook::Expenditem.create(:expend_id => @expend.id, :expense_id => item.id)
            item.pay!
          end
        end

        if @expend.salary?
          #need to pass in salary id so correct record can be updated
          salary = Mjbook::Salary.where(:id => params[:salary_id]).first
          Mjbook::Expenditem.create(:expend_id => @expend.id, :salary_id => salary.id)
          salary.pay!
        end

        add_account_expend_record(@expend)

        redirect_to expends_path, notice: 'Expenditure record was successfully created.'

      else
        render :new
      end
    end

    # PATCH/PUT /expends/1
    def update
      authorize @expend
      old_amount = @expend.dup
      if @expend.update(expend_params)
        update_account_expend_record(@expend)
        new_ammount = old_amount.total - @expend.total

        redirect_to expends_path, notice: 'Expenditure was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /expends/1
    def destroy
      authorize @expend

      #change state of associated expenses to 'accepted', i.e. not paid
      expenditems = Mjbook::Expenditem.where(:expend_id => @expend.id)
      expenditems.each do |item|

        if @expend.exp_type == 'business' || @expend.exp_type == 'personal'
          expense = Mjbook::Expense.where(:id => item.expense_id).first
          expense.correct!
        end

        if @expend.exp_type == 'salary'
          salary = Mjbook::Salary.where(:id => item.salary_id).first
          salary.correct!
        end

      end

      delete_account_expend_record(@expend)

      @expend.destroy #also destroys expenditem 
      redirect_to expends_path, notice: 'Expenditure record was successfully deleted.'
    end

    def reconcile
      authorize @expend
      #mark expense as rejected
      if @expend.reconcile!
        respond_to do |format|
          format.js   { render :reconcile, :layout => false }
        end 
      end 
    end

    def unreconcile
      authorize @expend
      #mark expense as rejected
      if @expend.unreconcile!
        respond_to do |format|
          format.js   { render :unreconcile, :layout => false }
        end 
      end 
    end



    private
      # Use callbacks to share common setup or constraints between actions.
      def set_expend
        @expend = Expend.find(params[:id])
      end

      def set_accounts
        @companyaccounts = policy_scope(Companyaccount)
      end

      def set_paymethods
        @paymethods = Mjbook::Paymethod.all
      end

      # Only allow a trusted parameter "white list" through.
      def expend_params
        params.require(:expend).permit(:company_id, :exp_type, :user_id, :paymethod_id, :companyaccount_id, :expend_receipt, :date, :ref, :price, :vat, :total, :state, :note)
      end


      def pdf_expend_index(expends, hmrcexpcat_id, date_from, date_to)
         download_filename(hmrcexpcat_id)

         document = Prawn::Document.new(
                    :page_size => "A4",
                    :page_layout => :landscape,
                    :margin => [10.mm, 10.mm, 5.mm, 10.mm]
                    ) do |pdf|
                      table_indexes(expends, 'expend', filter_group, date_from, date_to, filename, pdf)
                    end

          send_data document.render, filename: (filename+".pdf"), :type => "application/pdf"
      end

      def csv_expend_index(expends, hmrcexpcat_id)
         download_filename(hmrcexpcat_id)
         send_data expends.to_csv, filename: (filename+".csv"), :type => "text/csv"
      end

      def download_filename(hmrcexpcat_id)
         if account_id != ""
           companyaccount = Mjbook::Companyaccount.where(:id => account_id).first
           filter_group = companyaccount.name
         else
           filter_group = "All Accounts"
         end

         filename = "Business_expenses_#{ filter_group }_#{ date_from }_#{ date_to }"
      end


      def add_account_expend_record(expend)

        #CHECK ACCOUNTING PERIOD
        accounting_period(expend.date)

        #if expend date before account create date
        if expend.date < expend.companyaccount.date
          #get next expend for account in date order
          from_date = expend.date
          to_date = 1.day.ago(expend.companyaccount.date)
          next_record = policy_scope(Summary).where(:companyaccount_id => expend.companyaccount_id
                                            ).where(:date => [from_date..to_date]
                                            ).order("date DESC").order("id DESC").first
          #if exists
          if !next_record.blank?
            #new value =  next value - subtract expend value
            if next_record.amount_out == nil
              new_account_balance = next_record.account_balance - next_record.amount_in
            else
              new_account_balance = next_record.account_balance + next_record.amount_out
            end
          else
            new_account_balance = expend.companyaccount.balance
          end

          #update records before current date
          add_to_prior_transactions(expend)

          #update retained total for previous accounting periods
          #subtract payment to previous periods
          previous_periods = policy_scope(Period).where('year_start <= ?', 1.year.ago(expend.date))
          if !previous_periods.blank?
            previous_periods.each do |period|
              period.update(:retained => (period.retained + expend.total))
            end
          end


        #if expend date after account create date 
        else
          #get last expend before
          to_date = expend.date
          from_date = expend.companyaccount.date
          previous_record = policy_scope(Summary).where(:companyaccount_id => expend.companyaccount_id
                                                ).where(:date => [from_date..to_date]
                                                ).order(:date, :id).last

          if !previous_record.blank?
            new_account_balance = previous_record.account_balance - expend.total
          else
            new_account_balance = expend.companyaccount.balance - expend.total
          end

          #update subsequent expend records
          subtract_from_subsequent_transactions(expend)

          #update retained total for subsequent accounting periods
          #add payment to period retained amount
          @period.update(:retained => (@period.retained - expend.total))
          #update_subsequent_periods(payment)
          subsequent_periods = policy_scope(Period).where('year_start >= ?', 1.year.from_now(expend.date))
          if !subsequent_periods.blank?
            subsequent_periods.each do |period|
              period.update(:retained => (period.retained - expend.total))
            end
          end


        end

        Mjbook::Summary.create(:company_id => current_user.company_id,
                               :date => expend.date,
                               :companyaccount_id => expend.companyaccount_id,
                               :expend_id => expend.id,
                               :amount_in => expend.total,
                               :account_balance => new_account_balance)

      end


#      def update_account_expend_record(expend)
#        account_record = Summary.where(:expend_id => expend.id).first
#        variation = expend.total - account_record.amount_out
#        #if expend date before account create date
#        if expend.date < expend.companyaccount.date
#          #update records before current date
#          subtract_from_prior_transactions(expend)
#        else
#          #update subsequent expend records
#          add_to_subsequent_transactions(expend)
#        end

#        record_balance = account_balance - variation
#        account_record.update(:amount_out => expend.total, :account_balance => record_balance)

#        #get applicable accounting period
#        #update retained value in period
#        update_year_end("change", expend.total, expend.date)

#      end


      def delete_account_expend_record(expend)

        accounting_period(expend.date)

        account_record = Summary.where(:expend_id => expend.id).first
        #if expend date before account create date
        if expend.date < expend.companyaccount.date
          #update records before current date
          subtract_from_prior_transactions(expend)
          subtract_from_subsequent_transactions_on_date(expend, account_record)

          #update retained total for previous accounting periods
          #subtract payment to previous periods
          previous_periods = policy_scope(Period).where('year_start <= ?', 1.year.ago(expend.date))
          if !previous_periods.blank?
            previous_periods.each do |period|
              period.update(:retained => (period.retained - expend.total))
            end
          end

        else
          #update subsequent expend records
          add_to_subsequent_transactions(expend)
          add_to_subsequent_transactions_on_date(expend, account_record)

          #update retained amount for
          #update retained total for subsequent accounting periods
          #add payment to period retained amount
          @period.update(:retained => (@period.retained + expend.total))
          #update_subsequent_periods(payment)
          subsequent_periods = policy_scope(Period).where('year_start >= ?', 1.year.from_now(expend.date))
          if !subsequent_periods.blank?
            subsequent_periods.each do |period|
              period.update(:retained => (period.retained + expend.total))
            end
          end
        end

        #find account record to delete
        account_record.destroy

      end


      def subtract_from_prior_transactions(expend)
          #find records to update
          prior_transactions = policy_scope(Summary).where(:companyaccount_id => expend.companyaccount_id
                                                   ).where('date < ?', expend.date)
          #update prior balances
          if !prior_transactions.blank?
            subtract_amount_from(prior_transactions, expend.total)
          end
      end

      def add_to_subsequent_transactions(expend)
          #find records to update
          subsequent_transactions = policy_scope(Summary).where(:companyaccount_id => expend.companyaccount_id
                                                        ).where('date > ?', expend.date)
          #update prior balances
          if !subsequent_transactions.blank?
            add_amount_to(subsequent_transactions, expend.total)
          end
      end


      def add_to_prior_transactions(expend)
          #find records to update
          prior_transactions = policy_scope(Summary).where(:companyaccount_id => expend.companyaccount_id
                                                   ).where('date < ?', expend.date)
          #update prior balances
          if !prior_transactions.blank?
            add_amount_to(prior_transactions, expend.total)
          end
      end


      def subtract_from_subsequent_transactions(expend)
          #find records to update
          subsequent_transactions = policy_scope(Summary).where(:companyaccount_id => expend.companyaccount_id
                                                        ).where('date > ?', expend.date)
          #update prior balances
          if !subsequent_transactions.blank?
            subtract_amount_from(subsequent_transactions, expend.total)
          end
      end


      def add_to_subsequent_transactions_on_date(expend, account_record)
          prior_transactions = policy_scope(Summary).where(:companyaccount_id => expend.companyaccount_id
                                                   ).where(:date => expend.date
                                                   ).where('id > ?',account_record.id)
          if !prior_transactions.blank?
            add_amount_to(prior_transactions, expend.total)
          end
      end


      def subtract_from_subsequent_transactions_on_date(expend, account_record)
          #find records to update
          subsequent_transactions = policy_scope(Summary).where(:companyaccount_id => expend.companyaccount_id
                                                   ).where(:date => expend.date
                                                   ).where('id > ?',account_record.id)
          #update prior balances
          if !subsequent_transactions.blank?
            subtract_amount_from(subsequent_transactions, expend.total)
          end
      end


  end
end
