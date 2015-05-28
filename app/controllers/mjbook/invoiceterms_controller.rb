require_dependency "mjbook/application_controller"

module Mjbook
  class InvoicetermsController < ApplicationController
    before_action :set_invoiceterm, only: [:edit, :update, :destroy]

    include PrintIndexes

    # GET /invoiceterms
    def index
      @invoiceterms = policy_scope(Invoiceterm)
    end

    # GET /invoiceterms/new
    def new
      @invoiceterm = Invoiceterm.new
    end

    # GET /invoiceterms/1/edit
    def edit
      authorize @invoiceterm
    end

    # POST /invoiceterms
    def create
      @invoiceterm = Invoiceterm.new(invoiceterm_params)
      authorize @invoiceterm
      if @invoiceterm.save
        redirect_to invoiceterms_path, notice: 'Invoiceterm was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /invoiceterms/1
    def update
      authorize @invoiceterm
      if @invoiceterm.update(invoiceterm_params)
        redirect_to invoiceterms_path, notice: 'Invoiceterm was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /invoiceterms/1
    def destroy
      authorize @invoiceterm
      @invoiceterm.destroy
      redirect_to invoiceterms_url, notice: 'Invoiceterm was successfully destroyed.'
    end

    def print
      @invoiceterm = Invoiceterm.where(:company_id => params[:id]).first
      authorize @invoiceterm
      invoiceterms = Invoiceterm.where(:company_id => params[:id])

      filename = "Inovice Terms.pdf"

      document = Prawn::Document.new(
        :page_size => "A4",
        :page_layout => :landscape,
        :margin => [10.mm, 10.mm, 5.mm, 10.mm]
      ) do |pdf|
        table_indexes(invoiceterms, 'term', nil, nil, nil, filename, pdf)
      end

      send_data document.render, filename: filename, :type => "application/pdf"        
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_invoiceterm
        @invoiceterm = Invoiceterm.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def invoiceterm_params
        params.require(:invoiceterm).permit(:company_id, :ref, :period, :terms)
      end
  end
end
