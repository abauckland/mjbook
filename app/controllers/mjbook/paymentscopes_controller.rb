require_dependency "mjbook/application_controller"

module Mjbook
  class PaymentscopesController < ApplicationController

    # GET /payments/new
    def new
      @payment = Mjbook::Payment.new
      
      @invoice = Mjbook::Invoice.where(:id => params[:invoice_id]).first #id of invoice      
      @ingroups = Mjbook::Ingroup.includes(:inlines).where(:invoice_id => params[:invoice_id])  
      
    end

    # POST /payments
    def create


    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_payment
        @payment = Payment.find(params[:id])
      end


  end
end
