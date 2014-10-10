require_dependency "mjbook/application_controller"

module Mjbook
  class ProductsController < ApplicationController
    before_action :set_products, only: [:index]
    before_action :set_product, only: [:show, :edit, :update, :destroy]

    # GET /products
    def index
    end
    
    def item_options
      @products = Product.where(:company_id => current_user.company_id)
  
      #create hash of options
      @product_options = {}
      
      @products.each do |p|
        key = p.id
        value = p.item
        @product_options[key] = value
      end
      #render as json for jeditable
      render :json => @product_options
    end

    # GET /products/new
    def new
      @product = Product.new
    end

    # GET /products/1/edit
    def edit
    end

    # POST /products
    def create
      @product = Product.new(product_params)
      #calculate cost field for product
      vat = Mjbook::VAT.where(:id => product_params[:vat_id]).first      
      @product.cost = product_params[:price]*(1/vat.rate)

      if @product.save
        redirect_to @product, notice: 'Product was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /products/1
    def update      
      if @product.update(product_params)

        #calculate cost field for product and update
        vat = Mjbook::VAT.where(:id => product_params[:vat_id]).first      
        cost = product_params[:price]*(1/vat.rate)
        @product.update(:cost => cost)        
        
        redirect_to @product, notice: 'Product was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /products/1
    def destroy
      @product.destroy
      redirect_to products_url, notice: 'Product was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_products
        @products = Product.where(:company_id => current_user.company_id).order(:item)
      end

      def set_product
        @product = Product.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def product_params
        params.require(:product).permit(:company_id, :productcategory_id, :item, :quantity, :unit_id, :cost, :vat_id, :vat, :price)
      end
  end
end
