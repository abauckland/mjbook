require_dependency "mjbook/application_controller"

module Mjbook
  class TransfersController < ApplicationController
    before_action :set_transfer, only: [:show, :edit, :update, :destroy, :process_transfer]
    before_action :set_companyaccounts, only: [:new, :edit]
    before_action :set_paymethods, only: [:new, :edit]
    
    # GET /transfers
    def index
      @transfers = policy_scope(Transfer)
    end

    # GET /transfers/new
    def new
      @transfer = Transfer.new
      authorize @transfer
    end

    # GET /transfers/1/edit
    def edit
      authorize @transfer
    end

    # POST /transfers
    def create
      @transfer = Transfer.new(transfer_params)
      authorize @transfer
      if @transfer.save
        redirect_to transfers_path, notice: 'Transfer was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /transfers/1
    def update
      authorize @transfer
      if @transfer.update(transfer_params)
        redirect_to transfers_path, notice: 'Transfer was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /transfers/1
    def destroy
      authorize @transfer
      @transfer.destroy
      redirect_to transfers_url, notice: 'Transfer was successfully destroyed.'
    end

    def process_transfer
      authorize @transfer
      #add expend record
      @expend = Mjbook::Expend.new(
                          :company_id => @transfer.company_id,
                          :user_id => @transfer.user_id,
                          :date => @transfer.date,
                          :companyaccount_id => @transfer.account_from_id,
                          :paymethod_id => @transfer.paymethod_id,
                          :total => @transfer.total,
                          :exp_type => 'transfer',
                          :state => 'paid'
                          )
      if @expend.save
        Mjbook::Expenditem.create(:expend_id => @expend.id, :transfer_id => @transfer.id)  
        #add payment record
        @payment = Mjbook::Payment.new(
                          :company_id => @transfer.company_id,
                          :user_id => @transfer.user_id,
                          :date => @transfer.date,
                          :companyaccount_id => @transfer.account_to_id,
                          :paymethod_id => @transfer.paymethod_id,
                          :total => @transfer.total,
                          :inc_type => 'transfer',
                          :state => 'paid'
        )
        
        if @payment.save
            Mjbook::Paymentitem.create(:payment_id => @payment.id, :transfer_id => @transfer.id)

        end
      end
      @transfer.transfer!      
      redirect_to transfers_url, notice: 'Transfer was successfully recorded.'

    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_transfer
        @transfer = Transfer.find(params[:id])
      end

      def set_companyaccounts     
        @companyaccounts = policy_scope(Companyaccount) 
      end

      def set_paymethods     
        @paymethods = Mjbook::Paymethod.all
      end


      # Only allow a trusted parameter "white list" through.
      def transfer_params
        params.require(:transfer).permit(:company_id, :user_id, :account_from_id, :account_to_id, :paymethod_id, :total, :date, :state)
      end
  end
end
