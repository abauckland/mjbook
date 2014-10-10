require_dependency "mjbook/application_controller"

module Mjbook
  class ProductcategoriesController < ApplicationController
    before_action :set_productcategories, only: [:index, :list_categories]
    before_action :set_productcategory, only: [:show, :edit, :update, :destroy]

    # GET /productcategories
    def index
    end
    
    def cat_options
      @productcats = Productcategory.where(:company_id => current_user.company_id)
  
      #create hash of options
      @productcat_options = {}
      
      @productcats.each do |p|
        key = p.id
        value = p.name
        @productcat_options[key] = value
      end
      #render as json for jeditable
      render :json => @productcat_options
    end


    # GET /productcategories/new
    def new
      @productcategory = Productcategory.new
    end

    # GET /productcategories/1/edit
    def edit
    end

    # POST /productcategories
    def create
      @productcategory = Productcategory.new(productcategory_params)

      if @productcategory.save
        redirect_to @productcategory, notice: 'Productcategory was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /productcategories/1
    def update
      if @productcategory.update(productcategory_params)
        redirect_to @productcategory, notice: 'Productcategory was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /productcategories/1
    def destroy
      @productcategory.destroy
      redirect_to productcategories_url, notice: 'Productcategory was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_productcategories
        @productcategories = Productcategory.where(:company_id => current_user.company_id).order(:name)
      end
      
      def set_productcategory
        @productcategory = Productcategory.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def productcategory_params
        params.require(:productcategory).permit(:company_id, :name)
      end
  end
end
