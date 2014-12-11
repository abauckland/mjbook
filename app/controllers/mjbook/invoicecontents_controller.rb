require_dependency "mjbook/application_controller"

module Mjbook
  class InvoicecontentsController < ApplicationController
    before_action :set_invoice, only: [:show]

    def show
      @ingroups = Mjbook::Ingroup.where(:invoice_id => params[:id])
    end
    

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_invoice
        @invoice = Invoice.find(params[:id])
      end

  end
end
