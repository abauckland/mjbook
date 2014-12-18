require_dependency "mjbook/application_controller"

module Mjbook
  class ProductsController < ApplicationController
    before_action :set_products, only: [:index]
    before_action :set_product, only: [:show, :edit, :update, :destroy]
    before_action :set_categories, only: [:new, :edit]

    include PrintIndexes
    
    # GET /products
    def index
    end
    
    def quote_item_options

# HACK unclear why nessting does not work here!     
      @line = Qline.find(params[:id])
      @products = Product.joins(:productcategory).where('mjbook_productcategories.text' => @line.cat)
  
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


    def invoice_item_options

# HACK unclear why nessting does not work here!     
      @line = Inline.find(params[:id])
      @products = Product.joins(:productcategory).where('mjbook_productcategories.text' => @line.cat)
  
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


    def cat_item_options
    
      @products = policy_scope(Product).where(:linetype => 0).order(:item)
  
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
      vat = Mjbook::Vat.where(:id => product_params[:vat_id]).first
      quantity = product_params[:quantity].to_d
      rate = product_params[:rate].to_d
      price = (quantity*rate)
      vat_rate = vat.rate
      vat_due = price*(vat_rate/100)
      total = price+vat_due
      
      @product.price = price
      @product.vat_due = vat_due           
      @product.total = total

      if @product.save
        redirect_to products_path, notice: 'Product was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /products/1
    def update      
      if @product.update(product_params)

        #calculate cost field for product and update
        vat = Mjbook::Vat.where(:id => product_params[:vat_id]).first
        quantity = product_params[:quantity].to_d
        rate = product_params[:rate].to_d
        price = (quantity*rate)
        vat_rate = vat.rate
        vat_due = price*(vat_rate/100)
        total = price+vat_due
        
        @product.update(:price => price, :vat_due => vat_due, :total => total)     
        
        redirect_to products_path, notice: 'Product was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /products/1
    def destroy
      @product.destroy
      redirect_to products_path, notice: 'Product was successfully destroyed.'
    end

    def print
        
      products = Product.where(:company_id => current_user.company_id, :linetype => 0).order(:item)
         
      filename = "Products (variable sum).pdf"
                 
      document = Prawn::Document.new(
        :page_size => "A4",
        :page_layout => :landscape,
        :margin => [10.mm, 10.mm, 5.mm, 10.mm]
      ) do |pdf|      
        table_indexes(products, 'product', nil, nil, nil, filename, pdf)      
      end

      send_data document.render, filename: filename, :type => "application/pdf"        
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_products
        @products = policy_scope(Product).where(:linetype => 0).order(:item)
      end

      def set_product
        @product = Product.find(params[:id])
      end
      
      def set_categories
        @productcategories = policy_scope(Productcategory).order(:text)
      end

      # Only allow a trusted parameter "white list" through.
      def product_params
        params.require(:product).permit(:company_id, :productcategory_id, :item, :quantity, :unit_id, :rate, :vat_id, :vat, :price, :total, :linetype)
      end
  end
end
