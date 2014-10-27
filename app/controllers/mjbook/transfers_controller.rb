require_dependency "mjbook/application_controller"

module Mjbook
  class TransfersController < ApplicationController
    before_action :set_transfer, only: [:show, :edit, :update, :destroy, :reconcile]

    # GET /transfers
    def index
      @transfers = Transfer.all
    end

    # GET /transfers/new
    def new
      @transfer = Transfer.new
    end

    # GET /transfers/1/edit
    def edit
    end

    # POST /transfers
    def create
      @transfer = Transfer.new(transfer_params)

      if @transfer.save
        redirect_to @transfer, notice: 'Transfer was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /transfers/1
    def update
      if @transfer.update(transfer_params)
        redirect_to @transfer, notice: 'Transfer was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /transfers/1
    def destroy
      @transfer.destroy
      redirect_to transfers_url, notice: 'Transfer was successfully destroyed.'
    end

    def reconcile
      #mark expense as rejected
      authorize @transfer
      if @transfer.update(:status => "reconciled")
        respond_to do |format|
          format.js   { render :reconcile, :layout => false }
        end 
      end 
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_transfer
        @transfer = Transfer.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def transfer_params
        params.require(:transfer).permit(:company_id, :user_id, :account_from_id, :account_to_id, :total, :date, :status)
      end
  end
end
