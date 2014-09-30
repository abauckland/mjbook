require_dependency "mjbook/application_controller"

module Mjbook
  class QgroupsController < ApplicationController
    before_action :set_qgroup, only: [:show, :edit, :update, :destroy]

    # GET /qgroups
    def index
      @qgroups = Qgroup.all
    end

    # GET /qgroups/1
    def show
    end

    # GET /qgroups/new
    def new
      @qgroup = Qgroup.new
    end

    # GET /qgroups/1/edit
    def edit
    end

    # POST /qgroups
    def create
      @qgroup = Qgroup.new(qgroup_params)

      if @qgroup.save
        redirect_to @qgroup, notice: 'Qgroup was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /qgroups/1
    def update
      if @qgroup.update(qgroup_params)
        redirect_to @qgroup, notice: 'Qgroup was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /qgroups/1
    def destroy
      @qgroup.destroy
      redirect_to qgroups_url, notice: 'Qgroup was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_qgroup
        @qgroup = Qgroup.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def qgroup_params
        params.require(:qgroup).permit(:quote_id, :ref, :text, :sub_vat, :sub_price)
      end
  end
end
