require_dependency "mjbook/application_controller"

module Mjbook
  class MiscsController < ApplicationController
    before_action :set_miscs, only: [:index]
    before_action :set_misc, only: [:show, :edit, :update, :destroy]
    before_action :set_categories, only: [:new, :edit]

    include PrintIndexes

    # GET /products
    def index
    end

    def item_options

# HACK unclear why nessting does not work here!
      @line = Qline.find(params[:id])
      @pmiscs = Product.joins(:productcategory).where('mjbook_productcategories.text' => @line.cat)
  
      #create hash of options
      @misc_options = {}

      @miscs.each do |p|
        key = p.id
        value = p.item
        @misc_options[key] = value
      end
      #render as json for jeditable
      render :json => @product_options
    end

    def cat_item_options

      @miscs = policy_scope(Product).order(:item)

      #create hash of options
      @misc_options = {}

      @miscs.each do |p|
        key = p.id
        value = p.item
        @misc_options[key] = value
      end
      #render as json for jeditable
      render :json => @misc_options
    end


    # GET /products/new
    def new
      @misc = Product.new
    end

    # GET /products/1/edit
    def edit
    end

    # POST /products
    def create
      @misc = Product.new(misc_params)

      if @misc.save
        redirect_to miscs_path, notice: 'Product was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /products/1
    def update
      if @misc.update(misc_params)
        redirect_to miscs_path, notice: 'Product was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /products/1
    def destroy
      @misc.destroy
      redirect_to miscs_path, notice: 'Product was successfully destroyed.'
    end

    def print

      miscs = Product.where(:company_id => current_user.company_id, :linetype => 2).order(:item)

      filename = "Miscellaneous Products/Services.pdf"

      document = Prawn::Document.new(
        :page_size => "A4",
        :page_layout => :landscape,
        :margin => [10.mm, 10.mm, 5.mm, 10.mm]
      ) do |pdf|
        table_indexes(miscs, 'misc', nil, nil, nil, filename, pdf)
      end

      send_data document.render, filename: filename, :type => "application/pdf"
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_miscs
        @miscs = policy_scope(Product).where(:linetype => 2).order(:item)
      end

      def set_misc
        @misc = Product.find(params[:id])
      end

      def set_categories
        @misccategories = policy_scope(Productcategory).order(:text)
      end

      # Only allow a trusted parameter "white list" through.
      def misc_params
        params.require(:product).permit(:company_id, :productcategory_id, :item, :quantity, :unit_id, :rate, :vat_id, :vat, :price, :total, :linetype)
      end
  end
end
