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



     @sum_price = @expends.pluck(:price).sum
     @sum_vat = @expends.pluck(:vat).sum
     @sum_total = @expends.pluck(:total).sum

     #selected parameters for filter form
     hmrcexpcats_ids = policy_scope(Expense).joins(:expends).where('mjbook_expend.company_id =?', current_user.company_id).pluck(:hmrcexpcats_id).uniq
     @hmrcexpcats = policy_scope(Hmrcexpcat).where(:id => hmrcexpcats_ids)
     @hmrcexpcat = params[:hmrcexpcat_id]
     @date_from = params[:date_from]
     @date_to = params[:date_to]

     authorize @expends
    end

    # GET /expends/1
    def show
      authorize @expend
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
        update_expend_year_end("add", @expend.total, @expend.date)


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
        update_expend_year_end("change", new_ammount, @expend.date)

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
      update_expend_year_end("delete", @expend.total, @expend.date)

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

        last_account_record = policy_scope(Summary).where('companyaccount_id = ? AND date <= ?', expend.companyaccount_id, expend.date).order('created_at').last

        new_account_balance = last_account_record.account_balance - expend.total

        Mjbook::Summary.create(:date => expend.date,
                               :companyaccount_id => expend.companyaccount_id,
                               :expend_id => expend.id,
                               :amount_out => expend.total,
                               :account_balance => new_account_balance)

        update_subsequent_expend_balances(expend, expend.total)

      end


      def update_account_expend_record(expend)

        account_record = Summary.where(:expend_id => expend.id).first

        variation = expend.total - account_record.amount_out
        record_balance = account_balance + variation
        account_record.update(:amount_out => expend.total, :account_balance => record_balance)

        update_subsequent_expend_balances(expend, variation)

      end


      def delete_account_expend_record(expend)
        #update subsequent totals
        update_subsequent_expend_balances(expend, expend.total)

        #find account record to delete
        account_record = Summary.where(:expend_id => expend.id).first
        account_record.destroy
      end


      def update_subsequent_expend_balances(expend, variation)
        account_transactions = policy_scope(Summary).subsequent_account_transactions(expend.companyaccount_id, expend.date)
        if !account_transactions.blank?
          account_transactions.each do |transaction|
            new_account_balance = transaction.account_balance + variation
            transaction.update(:balance => new_account_balance)
          end
        end
      end



    def update_expend_year_end(action, amount, date)
      #on create, update or delete expend item
      #determine year record to update based on date of transaction
      accounting_period(date)

      if action == "add" || action == "change"
        period.update(:retained => (period.retained + amount))
      end

      if action == "delete"
        period.update(:retained => (period.retained - amount))
      end
    end


  end
end
