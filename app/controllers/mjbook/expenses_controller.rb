require_dependency "mjbook/application_controller"

module Mjbook
  class ExpensesController < ApplicationController
    
    before_action :set_business, only: [:show_business, :create_business, :edit_business, :update_business, :destroy]
    before_action :set_personal, only: [:show_personal, :create_personal, :edit_personal, :update_personal, :destroy]
    before_action :set_suppliers, only: [:new_business, :new_personal, :edit_busines, :edit_personal]
    before_action :set_projects, only: [:personal, :new_business, :new_personal, :edit_busines, :edit_personal]
    before_action :set_hmrcexpcats, only: [:new_business, :new_personal, :edit_busines, :edit_personal]
    before_action :set_employees, only: [:employee]

    include PrintIndexes
    
         
    # GET /business
    def business

    if params[:supplier_id]
  
        if params[:supplier_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @businessexpenses = Expense.where(:date => params[:date_from]..params[:date_to], :supplier_id => params[:supplier_id]).business
            else
              @businessexpenses = Expense.where('date > ? AND supplier_id =?', params[:date_from], params[:supplier_id]).business
            end  
          else  
            if params[:date_to] != ""
              @businessexpenses = Expense.where('date < ? AND supplier_id = ?', params[:date_to], params[:supplier_id]).business
            end
          end   
        else
          if params[:date_from] != ""
            if params[:date_to] != ""
              @businessexpenses = Expense.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.company_id' => current_user.company_id).business
            else
              @businessexpenses = Expense.joins(:project).where('date > ? AND mjbook_projects.company_id = ?', params[:date_from], current_user.company_id).business
            end  
          else  
            if params[:date_to] != ""
              @businessexpenses = Expense.joins(:project).where('date < ? AND mjbook_projects.company_id = ?', params[:date_to], current_user.company_id).business
            else
              @businessexpenses = Expense.joins(:project).where('mjbook_projects.company_id' => current_user.company_id).business
            end     
          end
        end   
     
        if params[:commit] == 'pdf'          
          pdf_business_index(@businessexpenses, params[:supplier_id], params[:date_from], params[:date_to])      
        end
            
     else
       @businessexpenses = Expense.joins(:project).where('mjbook_projects.company_id' => current_user.company_id).business
     end          

     #selected parameters for filter form     
     @suppliers = Supplier.joins(:expenses => :project).where('mjbook_projects.company_id' => current_user.company_id)
     @supplier = params[:supplier_id]
     @date_from = params[:date_from]
     @date_to = params[:date_to]

    end

    # GET /personal
    def personal

    if params[:project_id]
  
        if params[:project_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @personalexpenses = Expense.where(:date => params[:date_from]..params[:date_to], :project_id => params[:project_id])          
            else
              @personalexpenses = Expense.where('date > ? AND project_id =?', params[:date_from], params[:project_id]) 
            end  
          else  
            if params[:date_to] != ""
              @personalexpenses = Expense.where('date < ? AND project_id = ?', params[:date_to], params[:project_id])            
            end
          end   
        else
          if params[:date_from] != ""
            if params[:date_to] != ""
              @personalexpenses = Expense.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.company_id' => current_user.company_id)          
            else
              @personalexpenses = Expense.joins(:project).where('date > ? AND mjbook_projects.company_id = ?', params[:date_from], current_user.company_id)  
            end  
          else  
            if params[:date_to] != ""
              @personalexpenses = Expense.joins(:project).where('date < ? AND mjbook_projects.company_id = ?', params[:date_to], current_user.company_id)            
            else
              @personalexpenses = Expense.joins(:project).where('mjbook_projects.company_id' => current_user.company_id)
            end     
          end
        end   
     
        if params[:commit] == 'pdf'          
          pdf_personal_index(@personalexpenses, params[:project_id], params[:date_from], params[:date_to])      
        end
            
     else
       @personalexpenses = Expense.joins(:project).where('mjbook_projects.company_id' => current_user.company_id, :user_id => current_user.id)       
     end          

     #selected parameters for filter form     
     @projects = Project.joins(:company).where('companys.user_id' => current_user.id)
     @project = params[:project_id]
     @date_from = params[:date_from]
     @date_to = params[:date_to] 

    end

    # GET /personal
    def employee
      
    if params[:user_id]
  
        if params[:user_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @employeeexpenses = Expense.where(:date => params[:date_from]..params[:date_to], :user_id => params[:user_id])          
            else
              @employeeexpenses = Expense.where('date > ? AND user_id =?', params[:date_from], params[:user_id]) 
            end  
          else  
            if params[:date_to] != ""
              @employeeexpenses = Expense.where('date < ? AND user_id = ?', params[:date_to], params[:user_id])            
            end
          end   
        else
          if params[:date_from] != ""
            if params[:date_to] != ""
              @employeeexpenses = Expense.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.company_id' => current_user.company_id)          
            else
              @employeeexpenses = Expense.joins(:project).where('date > ? AND mjbook_projects.company_id = ?', params[:date_from], current_user.company_id)  
            end  
          else  
            if params[:date_to] != ""
              @employeeexpenses = Expense.joins(:project).where('date < ? AND mjbook_projects.company_id = ?', params[:date_to], current_user.company_id)            
            else
              @employeeexpenses = Expense.joins(:project).where('mjbook_projects.company_id' => current_user.company_id)
            end     
          end
        end   
     
        if params[:commit] == 'pdf'          
          pdf_employee_index(@employeeexpenses, params[:user_id], params[:date_from], params[:date_to])      
        end
            
     else
       @employeeexpenses = Expense.joins(:project).where('mjbook_projects.company_id' => current_user.company_id)       
     end          

     #selected parameters for filter form     
     @users = User.where(:company_id => current_user.company_id)
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
        params.require(:expense).permit(:company_id, :user_id, :exp_type, :status, :project_id, :supplier_id, :hmrcexpcat_id, :mileage_id, :date, :due_date, :amount, :vat, :receipt, :recurrence, :ref, :supplier_ref)
      end
      
      def pdf_business_index(businessexpenses, supplier_id, date_from, date_to)
         supplier = Supplier.where(:id => supplier_id).first if supplier_id

         if supplier
           filter_group = supplier.company_name
         else
           filter_group = "All Suppliers"
         end
         
         filename = "Business_expenses_#{ filter_group }_#{ date_from }_#{ date_to }.pdf"
                 
         document = Prawn::Document.new(
          :page_size => "A4",
          :page_layout => :landscape,
          :margin => [10.mm, 10.mm, 5.mm, 10.mm]
          ) do |pdf|      
            table_indexes(businessexpenses, 'business', filter_group, date_from, date_to, filename, pdf)      
          end

          send_data document.render, filename: filename, :type => "application/pdf"        
      end

      def pdf_personal_index(personalexpenses, project_id, date_from, date_to)
         project = User.where(:id => user_id).first if user_id

         if project
           filter_group = project.name
         else
           filter_group = "All Employees"
         end
         
         filename = "Personal_expenses_#{ filter_group }_#{ date_from }_#{ date_to }.pdf"
                 
         document = Prawn::Document.new(
          :page_size => "A4",
          :page_layout => :landscape,
          :margin => [10.mm, 10.mm, 5.mm, 10.mm]
          ) do |pdf|      
            table_indexes(personalexpenses, 'personal', filter_group, date_from, date_to, filename, pdf)      
          end

          send_data document.render, filename: filename, :type => "application/pdf"        
      end

      def pdf_employee_index(employeeexpenses, user_id, date_from, date_to)
         user = User.where(:id => user_id).first if user_id

         if user
           filter_group =user.name
         else
           filter_group = "All Employees"
         end
         
         filename = "Employee_expenses_#{ filter_group }_#{ date_from }_#{ date_to }.pdf"
                 
         document = Prawn::Document.new(
          :page_size => "A4",
          :page_layout => :landscape,
          :margin => [10.mm, 10.mm, 5.mm, 10.mm]
          ) do |pdf|      
            table_indexes(employeeexpenses, 'employee', filter_group, date_from, date_to, filename, pdf)      
          end

          send_data document.render, filename: filename, :type => "application/pdf"        
      end
      
  end
end
