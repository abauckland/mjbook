require_dependency "mjbook/application_controller"

module Mjbook
  class PersonalsController < ApplicationController

    before_action :set_expense, only: [:show, :edit, :update, :destroy]
    before_action :set_suppliers, only: [:new, :edit]
    before_action :set_projects, only: [:new, :edit]
    before_action :set_hmrcexpcats, only: [:new, :edit]

    include PrintIndexes


    # GET /personal
    def index

    if params[:project_id]

        if params[:project_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @expenses = Expense.where(:date => params[:date_from]..params[:date_to], :project_id => params[:project_id]).user(current_user).personal
            else
              @expenses = Expense.where('date > ? AND project_id =?', params[:date_from], params[:project_id]).user(current_user).personal
            end
          else
            if params[:date_to] != ""
              @expenses = Expense.where('date < ? AND project_id = ?', params[:date_to], params[:project_id]).user(current_user).personal
            else
              @expenses = Expense.where(:project_id => params[:project_id]).user(current_user).personal
            end
          end
        else
          if params[:date_from] != ""
            if params[:date_to] != ""
              @expenses = Expense.joins(:project).where(:date => params[:date_from]..params[:date_to]).user(current_user).personal
            else
              @expenses = Expense.joins(:project).where('date > ?', params[:date_from]).user(current_user).personal
            end
          else
            if params[:date_to] != ""
              @expenses = Expense.joins(:project).where('date < ?', params[:date_to]).user(current_user).personal
            else
              @pexpenses = Expense.user(current_user).personal
            end
          end
        end

        if params[:commit] == 'pdf'
          pdf_personal_index(@expenses, params[:project_id], params[:date_from], params[:date_to])
        end

        if params[:commit] == 'csv'
          csv_personal_index(@expenses, params[:project_id], params[:date_from], params[:date_to])
        end

     else
       @expenses = Expense.user(current_user).personal
     end

     @sum_price = @expenses.pluck(:price).sum
     @sum_vat = @expenses.pluck(:vat).sum
     @sum_total = @expenses.pluck(:total).sum

     #selected parameters for filter form
     all_expenses = Expense.user(current_user).personal
     @projects = Project.joins(:expenses).where('mjbook_expenses.id' => all_expenses.ids)
     @projects = params[:project_id]
     @project = params[:project_id]
     @date_from = params[:date_from]
     @date_to = params[:date_to] 

    end


    # GET /expenses/1
    def show
#      authorize @expense
#      authorize(:personal, :show?)
    end

    # GET /new_personal
    def new
      @expense = Expense.new
    end

    # GET /expenses/1/edit
    def edit
#      authorize @expense
#      authorize(:personal, :show?)
    end


    # POST /expenses
    def create
      @expense = Expense.new(expense_params)
      @expense.due_date = Time.now.utc.end_of_month
#      authorize @expense
#      authorize(:personal, :create?)
      if @expense.save
          redirect_to personals_path, notice: 'Expense was successfully created.'            
      else
       # render :new
      end
    end

    # PATCH/PUT /expenses/1
    def update
#      authorize @expense
#      authorize(:personal, :update?)
      if @expense.update(expense_params)
        redirect_to personals_path, notice: 'Expense was successfully updated.'
      else
       # render :edit
      end 
    end

    # DELETE /expenses/1
    def destroy
#      authorize @expense
#      authorize(:personal, :destroy?)
      @expense.destroy
      redirect_to personals_path, notice: 'Expense was successfully destroyed.'
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
        @suppliers = Supplier.where(:company_id => current_user.company_id)
      end

      def set_hmrcexpcats
        @hmrcexpcats = policy_scope(Hmrcexpcat)#.where(:hmrcgroup_id => 2) #pesonal
      end

      # Only allow a trusted parameter "white list" through.
      def expense_params
        params.require(:expense).permit(:company_id, :user_id, :exp_type, :status, :project_id, :supplier_id, :hmrcexpcat_id, :mileage_id, :date, :due_date, :price, :vat, :total, :receipt, :recurrence, :ref, :supplier_ref)
      end


      def pdf_personal_index(expenses, project_id, date_from, date_to)
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
            table_indexes(expenses, 'personal', filter_group, date_from, date_to, filename, pdf)      
          end

          send_data document.render, filename: filename, :type => "application/pdf"        
      end

      def csv_personal_index(expenses, project_id, date_from, date_to)
         project = User.where(:id => user_id).first if user_id

         if project
           filter_group = project.name
         else
           filter_group = "All Employees"
         end
         
         filename = "Personal_expenses_#{ filter_group }_#{ date_from }_#{ date_to }.csv"

         send_data expenses.to_csv, filename: filename, :type => "text/csv"
      end


  end
end
