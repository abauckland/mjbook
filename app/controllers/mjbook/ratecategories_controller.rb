require_dependency "mjbook/application_controller"

module Mjbook
  class RatecategoriesController < ApplicationController
    before_action :set_ratecategories, only: [:index, :list_categories]
    before_action :set_ratecategory, only: [:show, :edit, :update, :destroy]

    # GET /ratecategories
    def index
    end
    
    def list_categories
      render :json => @ratecategories
    end


    # GET /ratecategories/new
    def new
      @ratecategory = Ratecategory.new
    end

    # GET /ratecategories/1/edit
    def edit
    end

    # POST /ratecategories
    def create
      @ratecategory = Ratecategory.new(ratecategory_params)

      if @ratecategory.save
        redirect_to @ratecategory, notice: 'ratecategory was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /ratecategories/1
    def update
      if @ratecategory.update(ratecategory_params)
        redirect_to @ratecategory, notice: 'ratecategory was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /ratecategories/1
    def destroy
      @ratecategory.destroy
      redirect_to ratecategories_url, notice: 'ratecategory was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_ratecategories
        @ratecategories = Ratecategory.where(:company_id => current_user.company_id).order(:name)
      end
      
      def set_ratecategory
        @ratecategory = Ratecategory.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def ratecategory_params
        params.require(:ratecategory).permit(:company_id, :name)
      end
  end
end
