require_dependency "mjbook/application_controller"

module Mjbook
  class ExpensesController < ApplicationController

    before_action :set_expense, only: [:accept, :reject]

    def accept
      authorize @expense
      #mark expense ready for payment
      if @expense.accept!
        respond_to do |format|
          format.js   { render :accept, :layout => false }
        end
      end
    end

    def reject
      authorize @expense
      #mark expense as rejected
      if @expense.reject!
        respond_to do |format|
          format.js   { render :reject, :layout => false }
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
