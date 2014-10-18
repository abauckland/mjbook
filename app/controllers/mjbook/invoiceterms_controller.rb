require_dependency "mjbook/application_controller"

module Mjbook
  class InvoicetermsController < ApplicationController
    before_action :set_invoiceterm, only: [:show, :edit, :update, :destroy]

    include PrintIndexes
    
    # GET /invoiceterms
    def index
      @invoiceterms = Invoiceterm.all
    end

    # GET /invoiceterms/1
    def show
    end

    # GET /invoiceterms/new
    def new
      @invoiceterm = Invoiceterm.new
    end

    # GET /invoiceterms/1/edit
    def edit
    end

    # POST /invoiceterms
    def create
      @invoiceterm = Invoiceterm.new(invoiceterm_params)

      if @invoiceterm.save
        redirect_to @invoiceterm, notice: 'Invoiceterm was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /invoiceterms/1
    def update
      if @invoiceterm.update(invoiceterm_params)
        redirect_to @invoiceterm, notice: 'Invoiceterm was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /invoiceterms/1
    def destroy
      @invoiceterm.destroy
      redirect_to invoiceterms_url, notice: 'Invoiceterm was successfully destroyed.'
    end

    def print
        
      invoiceterms = Invoiceterm.where(:company_id => current_user.company_id)
         
      filename = "Inovice Terms.pdf"
                 
      document = Prawn::Document.new(
        :page_size => "A4",
        :page_layout => :landscape,
        :margin => [10.mm, 10.mm, 5.mm, 10.mm]
      ) do |pdf|      
        table_indexes(invoiceterms, 'terms', nil, nil, nil, filename, pdf)      
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
        params.require(:invoiceterm).permit(:company_id, :terms)
      end
  end
end
