require_dependency "mjbook/application_controller"

module Mjbook
  class IngroupsController < ApplicationController
    before_action :set_ingroup, only: [:show, :edit, :update, :destroy]

    # GET /ingroups
    def index
      @ingroups = Ingroup.all
    end

    # GET /ingroups/1
    def show
    end

    # GET /ingroups/new
    def new
      @ingroup = Ingroup.new
    end

    # GET /ingroups/1/edit
    def edit
    end

    # POST /ingroups
    def create
      @ingroup = Ingroup.new(ingroup_params)

      if @ingroup.save
        redirect_to @ingroup, notice: 'Ingroup was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /ingroups/1
    def update
      if @ingroup.update(ingroup_params)
        redirect_to @ingroup, notice: 'Ingroup was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /ingroups/1
    def destroy
      @ingroup.destroy
      redirect_to ingroups_url, notice: 'Ingroup was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_ingroup
        @ingroup = Ingroup.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def ingroup_params
        params.require(:ingroup).permit(:invoice_id, :ref, :text, :price, :vat_due, :total, :group_order)
      end
  end
end
