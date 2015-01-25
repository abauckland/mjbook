require_dependency "mjbook/application_controller"

module Mjbook
  class EmployeesController < ApplicationController

    before_action :set_expense, only: [:show]

    include PrintIndexes


    # GET /personal
    def index

    if params[:user_id]

        if params[:user_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @expenses = policy_scope(Expense).where(:date => params[:date_from]..params[:date_to], :user_id => params[:user_id]).personal
            else
              @expenses = policy_scope(Expense).where('date > ? AND user_id =?', params[:date_from], params[:user_id]).personal
            end
          else
            if params[:date_to] != ""
              @expenses = policy_scope(Expense).where('date < ? AND user_id = ?', params[:date_to], params[:user_id]).personal
            else
              @expenses = policy_scope(Expense).where('date < ? AND user_id = ?', params[:date_to], params[:user_id]).personal
            end
          end
        else
          if params[:date_from] != ""
            if params[:date_to] != ""
              @expenses = policy_scope(Expense).where(:date => params[:date_from]..params[:date_to]).personal
            else
              @expenses = policy_scope(Expense).where('date > ?', params[:date_from]).personal
            end
          else
            if params[:date_to] != ""
              @expenses = policy_scope(Expense).where('date < ?', params[:date_to]).personal
            else
              @expenses = policy_scope(Expense).personal
            end
          end
        end

        if params[:commit] == 'pdf'
          pdf_employee_index(@expenses, params[:user_id], params[:date_from], params[:date_to])
        end

     else
       @expenses = policy_scope(Expense).personal
     end

     @sum_price = @expenses.pluck(:price).sum
     @sum_vat = @expenses.pluck(:vat).sum
     @sum_total = @expenses.pluck(:total).sum

     #selected parameters for filter form
     user_id_array = policy_scope(Expense).personal.pluck(:user_id).uniq    
     @users = User.where(:id => user_id_array)   
     @user = params[:user_id]
     @date_from = params[:date_from]
     @date_to = params[:date_to]

    end

    # GET /expenses/1
    def show
#      authorize @expense
#      authorize(:employee, :show?) # throws error
    end


    private
      def set_expense
        @expense = Expense.find(params[:id])
      end

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
