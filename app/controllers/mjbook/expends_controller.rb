require_dependency "mjbook/application_controller"

module Mjbook
  class ExpendsController < ApplicationController
    before_action :set_expend, only: [:show, :edit, :update, :destroy, :reconcile]
    before_action :set_accounts, only: [:edit, :pay_employee, :pay_business, :pay_salary]
    before_action :set_paymethods, only: [:edit, :pay_employee, :pay_business, :pay_salary]

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

     #selected parameters for filter form     
     @companyaccounts = policy_scope(Companyaccount)
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
      @expenses = Mjbook::Expense.joins(:project).where('mjbook_projects.company_id' => current_user.company_id, :status => 'accepted').business
      
    end

    # GET /expends/new

    def pay_employee

      expenses = Mjbook::Expense.where(:exp_type => 1, :user_id => params[:id], :status => 2)
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
          expense = Expense.where(:id => @expend.expense_id).first
          expense.update(:status => :paid)
        end

        if @expend.personal?
          expenses = Expense.where(:user_id => @expend.user_id, :exp_type => 1, :status => 2)
          expenses.each do |item|
            item.update(:status => :paid)            
          end          
        end

        if @expend.salary?
          
        end
        
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
      @expend.destroy
      redirect_to expends_path, notice: 'Expend was successfully destroyed.'
    end
    
    def reconcile
      authorize @expend
      #mark expense as rejected
      if @expend.update(:status => "reconciled")
        respond_to do |format|
          format.js   { render :reconcile, :layout => false }
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
        params.require(:expend).permit(:company_id, :exp_type, :user_id, :expense_id, :paymethod_id, :companyaccount_id, :expend_receipt, :date, :ref, :price, :vat, :total, :status, :note)
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

  end
end
