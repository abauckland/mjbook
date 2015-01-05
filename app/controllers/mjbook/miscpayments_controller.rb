require_dependency "mjbook/application_controller"

module Mjbook
  class MiscpaymentsController < ApplicationController
    before_action :set_miscpayment, only: [:show, :edit, :update, :destroy]

    # GET /miscpayments
    def index
      @miscpayments = Miscpayment.all
    end

    # GET /miscpayments/1
    def show
    end

    # GET /miscpayments/new
    def new
      @miscpayment = Miscpayment.new
    end

    # GET /miscpayments/1/edit
    def edit
    end

    # POST /miscpayments
    def create
      @miscpayment = Mispayment.new(miscpayment_params)

      if @miscpayment.save
        redirect_to @miscpayment, notice: 'Misc payment record was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /miscpayments/1
    def update
      if @miscpayment.update(miscpayment_params)
        redirect_to @miscpayment, notice: 'Misc payment record successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /miscpayments/1
    def destroy
      @miscpayment.destroy
      redirect_to miscpayments_url, notice: 'Misc payment record successfully deleted.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_miscpayment
        @miscpayment = Miscpayment.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def miscpayment_params
        params.require(:miscpayment).permit(:company_id, :user_id, :exp_type, :ref, :project_id, :hmrcexpcat_id, :date, :due_date, :price, :vat, :total, :item, :provider_id, :provider_ref, :receipt, :note, :state)
      end
  end
end
