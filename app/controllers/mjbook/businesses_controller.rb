require_dependency "mjbook/application_controller"

module Mjbook
  class BusinessesController < ApplicationController
    
    before_action :set_expense, only: [:show, :edit, :update, :destroy]
    before_action :set_suppliers, only: [:index, :new, :edit]
    before_action :set_projects, only: [:new, :edit]
    before_action :set_hmrcexpcats, only: [:new, :edit]

    include PrintIndexes
    
         
    # GET /business
    def index

    if params[:supplier_id]
  
        if params[:supplier_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @expenses = Expense.where(:date => params[:date_from]..params[:date_to], :supplier_id => params[:supplier_id]).business
            else
              @expenses = Expense.where('date > ? AND supplier_id =?', params[:date_from], params[:supplier_id]).business
            end  
          else  
            if params[:date_to] != ""
              @expenses = Expense.where('date < ? AND supplier_id = ?', params[:date_to], params[:supplier_id]).business
            end
          end   
        else
          if params[:date_from] != ""
            if params[:date_to] != ""
              @expenses = Expense.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.company_id' => current_user.company_id).business
            else
              @expenses = Expense.joins(:project).where('date > ? AND mjbook_projects.company_id = ?', params[:date_from], current_user.company_id).business
            end  
          else  
            if params[:date_to] != ""
              @expenses = Expense.joins(:project).where('date < ? AND mjbook_projects.company_id = ?', params[:date_to], current_user.company_id).business
            else
              @expenses = Expense.joins(:project).where('mjbook_projects.company_id' => current_user.company_id).business
            end     
          end
        end   
     
        if params[:commit] == 'pdf'          
          pdf_business_index(@expenses, params[:supplier_id], params[:date_from], params[:date_to])      
        end
            
     else
       @expenses = Expense.joins(:project).where('mjbook_projects.company_id' => current_user.company_id).business
     end          

     #selected parameters for filter form     
     @suppliers = Supplier.joins(:expenses => :project).where('mjbook_projects.company_id' => current_user.company_id)
     @supplier = params[:supplier_id]
     @date_from = params[:date_from]
     @date_to = params[:date_to]

    end

    # GET /expenses/1
    def show
    end

    # GET /new_personal
    def new
      @expense = Expense.new
    end

    # GET /expenses/1/edit
    def edit
    end

    # POST /expenses
    def create
      @expense = Expense.new(expense_params)
      @expense.due_date = Time.now.utc.end_of_month
      if @expense.save
          redirect_to businesses_path, notice: 'Expense was successfully created.'            
      else
       # render :new
      end
    end

    # PATCH/PUT /expenses/1
    def update
      if @expense.update(expense_params)
        redirect_to businesses_path, notice: 'Expense was successfully updated.'
      else
       # render :edit
      end
    end

    # DELETE /expenses/1
    def destroy
      @expense.destroy
      redirect_to businesses_path, notice: 'Expense was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_expense
        @expense = Expense.find(params[:id])
      end

      def set_projects     
        @projects = policy_scope(Project)
      end
      
      def set_suppliers     
        @suppliers = policy_scope(Supplier)
      end

      def set_hmrcexpcats
        @hmrcexpcats = policy_scope(Hmrcexpcat)#.where(:hmrcgroup_id => 1) #pesonal
      end

      
      # Only allow a trusted parameter "white list" through.
      def expense_params
        params.require(:expense).permit(:company_id, :user_id, :exp_type, :state, :project_id, :supplier_id, :hmrcexpcat_id, :mileage_id, :date, :due_date, :price, :vat, :total, :receipt, :recurrence, :ref, :supplier_ref)
      end
      
      def pdf_business_index(expenses, supplier_id, date_from, date_to)
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
            table_indexes(expenses, 'business', filter_group, date_from, date_to, filename, pdf)      
          end

          send_data document.render, filename: filename, :type => "application/pdf"        
      end

      
  end
end
