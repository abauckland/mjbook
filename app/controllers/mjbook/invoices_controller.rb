require_dependency "mjbook/application_controller"

module Mjbook
  class InvoicesController < ApplicationController
    before_action :set_invoice, only: [:show, :edit, :update, :destroy]
    before_action :set_invoiceterms, only: [:new, :edit]
    
    # GET /invoice
    def index
      @invoices = Invoice.all
    end

    # GET /invoice/1
    def show
    end

    # GET /invoice/new
    def new
      @invoice = Invoice.new
    end

    # GET /invoice/1/edit
    def edit
    end

    # POST /invoice
    def create
      @invoice = Invoice.new(invoice_params)

      if @invoice.save
        redirect_to @invoice, notice: 'Invoice was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /invoice/1
    def update
      if @invoice.update(invoice_params)
        redirect_to @invoice, notice: 'Invoice was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /invoice/1
    def destroy
      @invoice.destroy
      redirect_to invoice_url, notice: 'Invoice was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_invoice
        @invoice = Invoice.find(params[:id])
      end

      def set_invoiceterms
        @invoiceterms = Invoiceterm.where(:comany_id => current_user.company_id)        
      end

      # Only allow a trusted parameter "white list" through.
      def invoice_params
        params.require(:invoice).permit(:project_id, :ref, :customer_ref, :price, :vat_due, :total, :status, :date, :invoiceterms_id, :invoicetype_id)
      end
  end
end
