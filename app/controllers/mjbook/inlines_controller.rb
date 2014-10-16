require_dependency "mjbook/application_controller"

module Mjbook
  class InlinesController < ApplicationController
    before_action :set_inline, only: [:show, :edit, :update, :destroy]

    # GET /inlines
    def index
      @inlines = Inline.all
    end

    # GET /inlines/1
    def show
    end

    # GET /inlines/new
    def new
      @inline = Inline.new
    end

    # GET /inlines/1/edit
    def edit
    end

    # POST /inlines
    def create
      @inline = Inline.new(inline_params)

      if @inline.save
        redirect_to @inline, notice: 'Inline was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /inlines/1
    def update
      if @inline.update(inline_params)
        redirect_to @inline, notice: 'Inline was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /inlines/1
    def destroy
      @inline.destroy
      redirect_to inlines_url, notice: 'Inline was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_inline
        @inline = Inline.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def inline_params
        params.require(:inline).permit(:ingroup_id, :cat, :string, :item, :string, :quantity, :decimal, :unit_id, :integer, :rate, :decimal, :price, :decimal, :vat_id, :integer, :vat_due, :decimal, :total, :decimal, :note, :text, :line_order, :integer, :linetype, :integer)
      end
  end
end
