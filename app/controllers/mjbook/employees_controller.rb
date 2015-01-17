require_dependency "mjbook/application_controller"

module Mjbook
  class EmployeesController < ApplicationController
    
    before_action :set_expense, only: [:show]
    before_action :set_users, only: [:index]

    include PrintIndexes
    
         
    # GET /personal
    def index

    if params[:user_id]

        if params[:user_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @expenses = Expense.where(:date => params[:date_from]..params[:date_to], :user_id => params[:user_id]).company.personal
            else
              @expenses = Expense.where('date > ? AND user_id =?', params[:date_from], params[:user_id]).company.personal
            end
          else
            if params[:date_to] != ""
              @expenses = Expense.where('date < ? AND user_id = ?', params[:date_to], params[:user_id]).company.personal
            end
          end
        else
          if params[:date_from] != ""
            if params[:date_to] != ""
              @expenses = Expense.joins(:project).where(:date => params[:date_from]..params[:date_to]).company.personal
            else
              @expenses = Expense.joins(:project).where('date > ?', params[:date_from], current_user.company_id).company.personal
            end
          else
            if params[:date_to] != ""
              @expenses = Expense.joins(:project).where('date < ?', params[:date_to], current_user.company_id).company.personal
            else
              @expenses = Expense.company.personal
            end
          end
        end

        if params[:commit] == 'pdf'
          pdf_employee_index(@expenses, params[:user_id], params[:date_from], params[:date_to])
        end

     else
       @expenses = Expense.company.personal
     end
     
     #selected parameters for filter form     
     @user = params[:user_id]
     @date_from = params[:date_from]
     @date_to = params[:date_to]   
            
    end

    # GET /expenses/1
    def show
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_expense
        @expense = Expense.find(params[:id])
      end

      def set_users    
        @users = policy_scope(User)
      end
      
      # Only allow a trusted parameter "white list" through.
#      def expense_params
#        params.require(:expense).permit(:company_id, :user_id, :exp_type, :status, :project_id, :supplier_id, :hmrcexpcat_id, :mileage_id, :date, :due_date, :price, :vat, :total, :receipt, :recurrence, :ref, :supplier_ref)
#      end
      

      def pdf_employee_index(expenses, user_id, date_from, date_to)
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
            table_indexes(expenses, 'employee', filter_group, date_from, date_to, filename, pdf)      
          end

          send_data document.render, filename: filename, :type => "application/pdf"        
      end
      
  end
end
