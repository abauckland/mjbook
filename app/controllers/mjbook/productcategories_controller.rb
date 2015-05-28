require_dependency "mjbook/application_controller"

module Mjbook
  class ProductcategoriesController < ApplicationController
    before_action :set_productcategories, only: [:index, :list_categories]
    before_action :set_productcategory, only: [:show, :edit, :update, :destroy]

    # GET /productcategories
    def index
      authorize @productcategories
    end

    def cat_options
      @productcats = policy_scope(Productcategory).order(:text)

      #create hash of options
      @productcat_options = {}

      @productcats.each do |p|
        key = p.id
        value = p.text
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
      authorize @productcategory
    end

    # POST /productcategories
    def create
      @productcategory = Productcategory.new(productcategory_params)
      authorize @productcategory
      if @productcategory.save
        redirect_to productcategories_path, notice: 'Productcategory was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /productcategories/1
    def update
      authorize @productcategory
      if @productcategory.update(productcategory_params)
        redirect_to productcategories_path, notice: 'Productcategory was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /productcategories/1
    def destroy
      authorize @productcategory
      @productcategory.destroy
      redirect_to productcategories_path, notice: 'Productcategory was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_productcategories
        @productcategories = policy_scope(Productcategory).order(:text)
      end

      def set_productcategory
        @productcategory = Productcategory.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def productcategory_params
        params.require(:productcategory).permit(:company_id, :text)
      end
  end
end
