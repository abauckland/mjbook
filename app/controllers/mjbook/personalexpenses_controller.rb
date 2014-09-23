require_dependency "mjbook/application_controller"

module Mjbook
  class PersonalexpensesController < ApplicationController
    before_action :set_expense, only: [:show, :edit, :update, :destroy]
    before_action :set_suppliers, only: [:new, :edit]
    before_action :set_projects, only: [:new, :edit]
    before_action :set_hmrcexpcats, only: [:new, :edit]
            
    # GET /expenses
    def index
      #@expenses = Expense.where(:user_id => current_user.id).order(:date)
      @personalexpenses = Expense.all
      if @personalexpenses.blank?
        redirect_to new_personalexpense_path                
      else
        render :index
      end
    end

    # GET /expenses/1
    def show
    end

    # GET /expenses/new
    def new
      @personalexpense = Expense.new
    end

    # GET /expenses/1/edit
    def edit
    end

    # POST /expenses
    def create
      @expense = Expense.new(expense_params)

      if @expense.save
        redirect_to personalexpenses_path, notice: 'Expense was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /expenses/1
    def update
      if @expense.update(expense_params)
        redirect_to personalexpenses_path, notice: 'Expense was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /expenses/1
    def destroy
      @expense.destroy
      redirect_to personalexpenses_url, notice: 'Expense was successfully destroyed.'
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_expense
        @expense = Expense.find(params[:id])
      end

      def set_projects     
        @projects = Project.where(:company_id => current_user.company_id)
      end

      def set_suppliers     
        @suppliers = Supplier.where(:company_id => current_user.company_id)
      end

      def set_hmrcexpcats      
        @hmrcexpcats = Hmrcexpcat.all
      end
            
      # Only allow a trusted parameter "white list" through.
      def expense_params
        params.require(:expense).permit(:user_id, :project_id, :supplier_id, :hmrcexpcat_id, :issue_date, :due_date, :amount, :vat, :receipt, :recurrence, :ref, :supplier_ref, :status)
      end
  end
end
