require_dependency "mjbook/application_controller"

module Mjbook
  class ServicecategoriesController < ApplicationController
    before_action :set_servicecategories, only: [:index, :list_categories]
    before_action :set_servicecategory, only: [:show, :edit, :update, :destroy]

    # GET /servicecategories
    def index
    end
    
    def list_categories
      render :json => @servicecategories
    end


    # GET /servicecategories/new
    def new
      @servicecategory = Servicecategory.new
    end

    # GET /servicecategories/1/edit
    def edit
    end

    # POST /servicecategories
    def create
      @servicecategory = Servicecategory.new(servicecategory_params)

      if @servicecategory.save
        redirect_to @servicecategory, notice: 'servicecategory was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /servicecategories/1
    def update
      if @servicecategory.update(servicecategory_params)
        redirect_to @servicecategory, notice: 'servicecategory was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /servicecategories/1
    def destroy
      @servicecategory.destroy
      redirect_to servicecategories_url, notice: 'servicecategory was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_servicecategories
        @servicecategories = Servicecategory.where(:company_id => current_user.company_id).order(:name)
      end
      
      def set_servicecategory
        @servicecategory = Servicecategory.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def servicecategory_params
        params.require(:servicecategory).permit(:company_id, :name)
      end
  end
end
