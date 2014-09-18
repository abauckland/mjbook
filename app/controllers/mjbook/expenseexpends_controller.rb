require_dependency "mjbook/application_controller"

module Mjbook
  class ExpenseexpendsController < ApplicationController
    before_action :set_expenseexpend, only: [:show, :edit, :update, :destroy]

    # GET /expenseexpends
    def index
      @expenseexpends = Expenseexpend.all
    end

    # GET /expenseexpends/1
    def show
    end

    # GET /expenseexpends/new
    def new
      @expenseexpend = Expenseexpend.new
    end

    # GET /expenseexpends/1/edit
    def edit
    end

    # POST /expenseexpends
    def create
      @expenseexpend = Expenseexpend.new(expenseexpend_params)

      if @expenseexpend.save
        redirect_to @expenseexpend, notice: 'Expenseexpend was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /expenseexpends/1
    def update
      if @expenseexpend.update(expenseexpend_params)
        redirect_to @expenseexpend, notice: 'Expenseexpend was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /expenseexpends/1
    def destroy
      @expenseexpend.destroy
      redirect_to expenseexpends_url, notice: 'Expenseexpend was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_expenseexpend
        @expenseexpend = Expenseexpend.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def expenseexpend_params
        params.require(:expenseexpend).permit(:expense_id, :expenditure_id)
      end
  end
end
