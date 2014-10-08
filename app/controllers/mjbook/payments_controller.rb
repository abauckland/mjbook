require_dependency "mjbook/application_controller"

module Mjbook
  class PaymentsController < ApplicationController
    before_action :set_expenditure, only: [:show, :edit, :update, :destroy]

    # GET /expenditures
    def index
      @payments = Payment.all
    end

    def paid_personal
      #batch accepted expenses together
      
    end
    
    def paid_business
      
    end 

    def paid_salary
      
    end 

    # GET /expenditures/1
    def show
    end

    # GET /expenditures/new
    def new
      @payment = Payment.new
    end

    # GET /expenditures/1/edit
    def edit
    end

    # POST /expenditures
    def create
      @payment = Payment.new(expenditure_params)

      if @payment.save
        redirect_to @payment, notice: 'Expenditure was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /expenditures/1
    def update
      if @payment.update(expenditure_params)
        redirect_to @payment, notice: 'Expenditure was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /expenditures/1
    def destroy
      @payment.destroy
      redirect_to expenditures_url, notice: 'Expenditure was successfully destroyed.'
    end

    
    def pay_personal
      #batch accepted expenses together
      
    end
    
    def pay_business
      
    end 

    def pay_salary
      
    end 

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_expenditure
        @payment = Payment.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def expenditure_params
        params.require(:payment).permit(:amount, :date, :ref, :method, :user_id)
      end
  end
end
