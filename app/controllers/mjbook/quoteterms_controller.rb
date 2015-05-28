require_dependency "mjbook/application_controller"

module Mjbook
  class QuotetermsController < ApplicationController
    before_action :set_quoteterm, only: [:edit, :update, :destroy]

    include PrintIndexes

    # GET /quoteterms
    def index
      @quoteterms = policy_scope(Quoteterm)
    end

    # GET /quoteterms/new
    def new
      @quoteterm = Quoteterm.new
    end

    # GET /quoteterms/1/edit
    def edit
      authorize @quoteterm
    end

    # POST /quoteterms
    def create
      @quoteterm = Quoteterm.new(quoteterm_params)
      authorize @quoteterm
      if @quoteterm.save
        redirect_to quoteterms_path, notice: 'Quoteterm was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /quoteterms/1
    def update
      authorize @quoteterm
      if @quoteterm.update(quoteterm_params)
        redirect_to quoteterms_path, notice: 'Quoteterm was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /quoteterms/1
    def destroy
      authorize @quoteterm
      @quoteterm.destroy
      redirect_to quoteterms_path, notice: 'Quoteterm was successfully destroyed.'
    end

    def print
      @quoteterm = Quoteterm.where(:company_id => params[:id]).first
      authorize @quoteterm 
      quoteterms = Quoteterm.where(:company_id => params[:id])

      filename = "Quote Terms.pdf"

      document = Prawn::Document.new(
        :page_size => "A4",
        :page_layout => :landscape,
        :margin => [10.mm, 10.mm, 5.mm, 10.mm]
      ) do |pdf|
        table_indexes(quoteterms, 'term', nil, nil, nil, filename, pdf)
      end

      send_data document.render, filename: filename, :type => "application/pdf"
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_quoteterm
        @quoteterm = Quoteterm.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def quoteterm_params
        params.require(:quoteterm).permit(:company_id, :ref, :period, :terms)
      end
  end
end
