require_dependency "mjbook/application_controller"

module Mjbook
  class BusinessexpensesController < ApplicationController
    before_action :set_expense, only: [:show, :edit, :update, :destroy]

    # GET /expenses
    def index
      @expenses = Expense.all
    end

    # GET /expenses/1
    def show
    end

    # GET /expenses/new
    def new
      @expense = Expense.new
    end

    # GET /expenses/1/edit
    def edit
    end

    # POST /expenses
    def create
      @expense = Expense.new(expense_params)

      if @expense.save
        redirect_to @expense, notice: 'Expense was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /expenses/1
    def update
      if @expense.update(expense_params)
        redirect_to @expense, notice: 'Expense was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /expenses/1
    def destroy
      @expense.destroy
      redirect_to expenses_url, notice: 'Expense was successfully destroyed.'
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

      # Only allow a trusted parameter "white list" through.
      def expense_params
        params.require(:expense).permit(:user_id, :project_id, :supplier_id, :hmrcexpcat_id, :issue_date, :due_date, :amount, :vat, :receipt, :recurrence, :ref, :supplier_ref, :status)
      end
  end
end
