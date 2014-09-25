require_dependency "mjbook/application_controller"

module Mjbook
  class ExpendituresController < ApplicationController
    before_action :set_expenditure, only: [:show, :edit, :update, :destroy]

    # GET /expenditures
    def index
      @expenditures = Expenditure.all
    end

    # GET /expenditures/1
    def show
    end

    # GET /expenditures/new
    def new
      @expenditure = Expenditure.new
    end

    # GET /expenditures/1/edit
    def edit
    end

    # POST /expenditures
    def create
      @expenditure = Expenditure.new(expenditure_params)

      if @expenditure.save
        redirect_to @expenditure, notice: 'Expenditure was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /expenditures/1
    def update
      if @expenditure.update(expenditure_params)
        redirect_to @expenditure, notice: 'Expenditure was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /expenditures/1
    def destroy
      @expenditure.destroy
      redirect_to expenditures_url, notice: 'Expenditure was successfully destroyed.'
    end

    
    def pay_personal_expenses
      #batch accepted expenses together
      
    end
    
    def pay_business_expenses
      
    end 

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_expenditure
        @expenditure = Expenditure.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def expenditure_params
        params.require(:expenditure).permit(:amount, :date, :ref, :method, :user_id)
      end
  end
end
