require_dependency "mjbook/application_controller"

module Mjbook
  class ExpensesController < ApplicationController
    
    before_action :set_business, only: [:show_business, :create_business, :edit_business, :update_business, :destroy]
    before_action :set_personal, only: [:show_personal, :create_personal, :edit_personal, :update_personal, :destroy]
    before_action :set_suppliers, only: [:new_business, :new_personal, :edit_busines, :edit_personal]
    before_action :set_projects, only: [:business, :personal, :new_business, :new_personal, :edit_busines, :edit_personal]
    before_action :set_hmrcexpcats, only: [:new_business, :new_personal, :edit_busines, :edit_personal]
    before_action :set_employees, only: [:employee]

         
    # GET /business
    def business

      filter_hash = {}      
      
      if params[:project_id] #check if filter form is submitted
        if params[:project_id] != ""
          filter_hash['project_id'] = params[:project_id]
        end

        if params[:date_from] != ""
          if params[:date_to] != ""
            filter_hash['date'] = [params[:date_from]..params[:date_to]]           
          else
            filter_hash['date'] = params[:date_from]   
          end  
        else  
          if params[:date_to] != ""
            filter_hash['date'] = params[:date_to]             
          end
        end
      end
      
      #list expenses where status is not 'paid'
      if filter_hash.empty
        @businessexpenses = Expense.where(:company_id => current_user.company_id, :exp_type => 0).where.not(:status => 3).order(:date)
      else      
        @businessexpenses = Expense.where(filter_hash, :company_id => current_user.company_id, :exp_type => 0).where.not(:status => 3).order(:date)
      end
      
      #selected parameters for filter form
      @project = params[:project_id]
      @date_from = params[:date_from]
      @date_to = params[:date_to]

    end

    # GET /personal
    def personal
      
      filter_hash = {}      
      
      if params[:date_from] #check if filter form is submitted
        if params[:date_from] != ""
          if params[:date_to] != ""
            filter_hash['date'] = [params[:date_from]..params[:date_to]]           
          else
            filter_hash['date'] = params[:date_from]   
          end  
        else  
          if params[:date_to] != ""
            filter_hash['date'] = params[:date_to]             
          end
        end
      end      
      
      if filter_hash.empty?
        @personalexpenses = Expense.where(:user_id => current_user.id, :exp_type => 1).where.not(:status => 3).order(:date)
      else
        @personalexpenses = Expense.where(filter_hash, :user_id => current_user.id, :exp_type => 1).where.not(:status => 3).order(:date)  
      end
      
      #selected parameters for filter form
      @date_from = params[:date_from]
      @date_to = params[:date_to]
      
    end

    # GET /personal
    def employee
      
      filter_hash = {}      
      
      if params[:user_id] #check if filter form is submitted
        if params[:user_id] != ""
          filter_hash['user_id'] = params[:user_id]
        end

        if params[:date_from] != ""
          if params[:date_to] != ""
            filter_hash['date'] = [params[:date_from]..params[:date_to]]           
          else
            filter_hash['date'] = params[:date_from]   
          end  
        else  
          if params[:date_to] != ""
            filter_hash['date'] = params[:date_to]             
          end
        end
      end     
      
      if filter_hash.empty?
        @employeeexpenses = Expense.where(:company_id => current_user.company_id, :exp_type => 1).where.not(:status => 3).order(:date)
      else
        @employeeexpenses = Expense.where(filter_hash, :company_id => current_user.company_id, :exp_type => 1).where.not(:status => 3).order(:date)  
      end
      
      #selected parameters for filter form
      @user = params[:user_id]
      @date_from = params[:date_from]
      @date_to = params[:date_to]
      
    end



    # GET /expenses/1
    def show
    end

    # GET /new_business
    def new_business
      @businessexpense = Expense.new
    end

    # GET /new_personal
    def new_personal
      @personalexpense = Expense.new
    end

    # GET /expenses/1/edit
    def edit_business
    end

    # POST /expenses
    def create
      @expense = Expense.new(expense_params)

      if @expense.save
        if @expense.exp_type == "business"
          redirect_to business_path, notice: 'Expense was successfully created.'
        else
          redirect_to personal_path, notice: 'Expense was successfully created.'            
        end
      else
       # render :new
      end
    end

    # PATCH/PUT /expenses/1
    def update
      if @businessexpense.update(expense_params)
        redirect_to @businessexpense, notice: 'Expense was successfully updated.'
      else
       # render :edit
      end
    end

    # DELETE /expenses/1
    def destroy
      @businessexpense.destroy
      redirect_to expenses_url, notice: 'Expense was successfully destroyed.'
    end


    def accept
      #mark expense ready for payment
      @expense = Expense.where(:id => params[:id]).first 
      if @expense.update(:status => "accepted")        
        respond_to do |format|
          format.js   { render :accept, :layout => false }
        end  
      end      
    end 

    def reject
      #mark expense as rejected
      @expense = Expense.where(:id => params[:id]).first
      if @expense.update(:status => "rejected")
        respond_to do |format|
          format.js   { render :reject, :layout => false }
        end 
      end    
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_business
        @businessexpense = Expense.find(params[:id])
      end

      def set_personal
        @businessexpense = Expense.find(params[:id])
      end

      def set_projects     
        @projects = Project.where(:company_id => current_user.company_id)
      end
      
      def set_suppliers     
        @suppliers = Supplier.where(:company_id => current_user.company_id)
      end

      def set_hmrcexpcats      
        @hmrcexpcats = Hmrcexpcat.where(:group => "business")
      end

      def set_employees     
        @employees = User.where(:company_id => current_user.company_id)
      end
      
      # Only allow a trusted parameter "white list" through.
      def expense_params
        params.require(:expense).permit(:company_id, :user_id, :exp_type, :status, :project_id, :supplier_id, :hmrcexpcat_id, :date, :due_date, :amount, :vat, :receipt, :recurrence, :ref, :supplier_ref)
      end
  end
end
