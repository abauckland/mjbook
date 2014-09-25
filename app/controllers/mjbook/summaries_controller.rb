require_dependency "mjbook/application_controller"

module Mjbook
  class SummariesController < ApplicationController
    def index
      
      #@invoices_pending      
      #@invoices_due
      #@invoices_overdue
      #@payments_pending = Expense.where(:due_date => [(Time.after now)..(7.days.from_now)], :status => []).order(:date)  #payments due in 7 days
      #@payments_due = Expense.where(:due_date => [(Time.now)..(7.days.from_now)], :status => []).order(:date)  #payments due in 7 days
      #@payments_overdue = Expense.where(:due_date => [(Time.before now)], :status => []).order(:date)
      
      #current_cash
      #cash_projection
      
      #quotes_accepted_value      
      
      
    end
  end
end
