require_dependency "mjbook/application_controller"

module Mjbook
  class ExpendsController < ApplicationController
    before_action :set_expend, only: [:show, :edit, :update, :destroy, :reconcile, :unreconcile]
    before_action :set_accounts, only: [:edit, :pay_employee, :pay_business, :pay_salary, :pay_miscexpense]
    before_action :set_paymethods, only: [:edit, :pay_employee, :pay_business, :pay_salary, :pay_miscexpense]

    # GET /expends
    def index
    if params[:companyaccount_id]

        if params[:companyaccount_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @expends = policy_scope(Expend).where(:date => params[:date_from]..params[:date_to], :companyaccount_id => params[:companyaccount_id])
            else
              @expends = policy_scope(Expend).where('date > ? AND companyaccount_id =?', params[:date_from], params[:companyaccount_id])
            end
          else
            if params[:date_to] != ""
              @expends = policy_scope(Expend).where('date < ? AND companyaccount_id = ?', params[:date_to], params[:companyaccount_id])
            else
              @expends = policy_scope(Expend).where(:companyaccount_id => params[:companyaccount_id])
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

        if params[:commit] == 'pdf'
          pdf_expend_index(@expends, params[:companyaccount_id], params[:date_from], params[:date_to])      
        end

     else
       @expends = policy_scope(Expend)
     end

     @sum_price = @expends.pluck(:price).sum
     @sum_vat = @expends.pluck(:vat).sum
     @sum_total = @expends.pluck(:total).sum

     #selected parameters for filter form
     all_expends = policy_scope(Expend)
     @companyaccounts = Companyaccount.joins(:expends).where('mjbook_expends.id' => all_expends.ids)
     @companyaccount = params[:companyaccount_id]
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

    def pay_miscexpense
      @miscexpense = Mjbook::Miscexpense.where(:id => params[:id]).first
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

        if @expend.misc?
          #need to pass in miscexpense id so correct record can be updated
          miscexpense = Mjbook::Miscexpense.where(:id => params[:salary_id]).first
          Mjbook::Expenditem.create(:expend_id => @expend.id, :miscexpense_id => miscexpense.id)
          miscexpense.pay!
        end

        create_summary_record(@expend)
        add_summary_account_balance(@expend)
        add_summary_balance(@expend)

        redirect_to expends_path, notice: 'Expend was successfully created.'

      else
        render :new
      end
    end

    # PATCH/PUT /expends/1
    def update
      authorize @expend
      if @expend.update(expend_params)
        redirect_to expends_path, notice: 'Expend was successfully updated.'
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

        if @expend.exp_type == 'transfer'
          transfer = Mjbook::Transfer.where(:id => item.transfer_id).first
          transfer.correct!

          #if transfer is destoyed also need to destroy record of payment
          payment = Mjbook::Payment.joins(:paymentitems).where('mjbook_paymentitems.transfer_id' => transfer.id).first
          payment.destroy
        end

        if @expend.exp_type == 'misc'
          miscxexpense = Mjbook::Miscexpense.where(:id => item.miscexpense_id).first
          miscexpense.correct!
        end

      end

      delete_summary_record(@expend)
      delete_summary_account_balance(@expend)
      delete_summary_balance(@expend)

      @expend.destroy #also destroys expenditem 
      redirect_to expends_path, notice: 'Expend was successfully deleted.'
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

      def pdf_expend_index(expends, account_id, date_from, date_to)

         if account_id
           companyaccount = Mjbook::Companyaccount.where(:id => account_id).first
           filter_group = companyaccount.company_name
         else
           filter_group = "All Accounts"
         end

         filename = "Business_expenses_#{ filter_group }_#{ date_from }_#{ date_to }.pdf"

         document = Prawn::Document.new(
          :page_size => "A4",
          :page_layout => :landscape,
          :margin => [10.mm, 10.mm, 5.mm, 10.mm]
          ) do |pdf|      
            table_indexes(expends, 'expend', filter_group, date_from, date_to, filename, pdf)
          end

          send_data document.render, filename: filename, :type => "application/pdf"
      end


      def create_summary_record(expend)

        last_transaction = policy_scope(Summary).where('date <= ?', expend.date).order('created_at').last
        last_account_transaction = policy_scope(Summary).where('companyaccount_id = ? AND date <= ?', expend.companyaccount_id, expend.date).order('created_at').last

        if last_transaction.blank?
          new_balance = 0-expend.total
          new_account_balance = 0-expend.total
        else
          new_balance = last_transaction.balance - expend.total
          new_account_balance = last_transaction.account_balance - expend.total
        end

        Mjbook::Summary.create(:date => expend.date,
                                  :company_id => expend.company_id,
                                  :companyaccount_id => expend.companyaccount_id,
                                  :expend_id => expend.id,
                                  :amount_out => expend.total,
                                  :balance => new_balance,
                                  :account_balance => new_account_balance)
      end

      def add_summary_account_balance(expend)
        account_transactions = policy_scope(Summary).subsequent_account_transactions(expend.companyaccount_id, expend.date)
        if !account_transactions?
          account_transactions.each do |transaction|
            new_account_balance = transaction.account_balance - expend.total
            transaction.update(:balance => new_account_balance)
          end
        end
      end

      def add_summary_balance(expend)
        transactions = policy_scope(Summary).subsequent_transactions(expend.date)
        if !transactions.blank?
          transactions.each do |transaction|
            new_balance = transaction.balance - expend.total
            transaction.update(:balance => new_balance)
          end
        end
      end


      def delete_summary_record(expend)
        transaction = policy_scope(Summary).where(:expend_id => expend.id).first
        transaction.destroy
      end

      def delete_summary_account_balance(expend)
        account_transactions = policy_scope(Summary).subsequent_account_transactions(expend.companyaccount_id, expend.date)
        if !account_transactions.blank?
          account_transactions.each do |transaction|
            new_account_balance = transaction.account_balance + expend.total
            transaction.update(:balance => new_account_balance)
          end
        end
      end

      def delete_summary_balance(expend)
        transactions = policy_scope(Summary).subsequent_transactions(expend.date)
        if !transactions.blank?
          transactions.each do |transaction|
            new_balance = transaction.balance + expend.total
            transaction.update(:balance => new_balance)
          end
        end
      end

  end
end
