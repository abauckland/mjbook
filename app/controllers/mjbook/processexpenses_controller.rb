module Mjbook
  class ProcessexpensesController < ActionController::Base
    before_action :set_expense, only: [:accept_expense, :reject_expense]
    
    def index_personal
      #show list of personal expsenses only
      #filter by employee
      @users = User.where(:company_id => current_user.id)
      @expenses = Expense.where(:user_id => params[:id]).where.not(:status => "paid").order(:date)
      
    end

    def accept_expense
      #mark expense ready for payment
      if @expense.update(:status => "accepted")        
        respond_to do |format|
          format.js   { render :accept_expense, :layout => false }
        end  
      end      
    end    

    def reject_expense
      #mark expense as rejected
      if @expense.update(:status => "rejected")
        respond_to do |format|
          format.js   { render :reject_expense, :layout => false }
        end 
      end    
    end

    
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_expense
        @expense = Expense.find(params[:id])
      end
    
  end
end
