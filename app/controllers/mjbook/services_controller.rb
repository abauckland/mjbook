require_dependency "mjbook/application_controller"

module Mjbook
  class ServicesController < ApplicationController
    before_action :set_services, only: [:index]
    before_action :set_service, only: [:show, :edit, :update, :destroy]
    before_action :set_categories, only: [:new, :edit]

    include PrintIndexes
    
    # GET /products
    def index
    end
    
    def item_options

# HACK unclear why nessting does not work here!     
      @line = Qline.find(params[:id])
      @services = Product.joins(:productcategory).where('mjbook_productcategories.text' => @line.cat)
  
      #create hash of options
      @service_options = {}
      
      @services.each do |p|
        key = p.id
        value = p.item
        @service_options[key] = value
      end
      #render as json for jeditable
      render :json => @service_options
    end

    def cat_item_options
    
      @services = policy_scope(Product).where(:linetype => 1).order(:item)
  
      #create hash of options
      @service_options = {}
      
      @services.each do |p|
        key = p.id
        value = p.item
        @service_options[key] = value
      end
      #render as json for jeditable
      render :json => @service_options
    end


    # GET /products/new
    def new
      @service = Product.new
    end

    # GET /products/1/edit
    def edit
    end

    # POST /products
    def create
      @service = Product.new(service_params)
      #calculate cost field for product
      vat = Mjbook::Vat.where(:id => service_params[:vat_id]).first
      price = service_params[:price]
      vat_rate = vat.rate
      vat_due = price*(vat_rate/100)
      total = price+vat_due
      
      @service.vat_due = vat_due           
      @service.total = total

      if @service.save
        redirect_to services_path, notice: 'Product was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /products/1
    def update      
      if @service.update(service_params)

        #calculate cost field for product and update
        vat = Mjbook::Vat.where(:id => service_params[:vat_id]).first
        price = service_params[:price]
        vat_rate = vat.rate
        vat_due = price*(vat_rate/100)
        total = price+vat_due
        
        @service.update(:vat_due => vat_due, :total => total)     
        
        redirect_to services_path, notice: 'Service was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /products/1
    def destroy
      @service.destroy
      redirect_to services_path, notice: 'Service was successfully destroyed.'
    end

    def print
        
      services = Product.where(:company_id => current_user.company_id).order(:item)
         
      filename = "Services (lump sum).pdf"
                 
      document = Prawn::Document.new(
        :page_size => "A4",
        :page_layout => :landscape,
        :margin => [10.mm, 10.mm, 5.mm, 10.mm]
      ) do |pdf|      
        table_indexes(services, 'service', nil, nil, nil, filename, pdf)      
      end

      send_data document.render, filename: filename, :type => "application/pdf"        
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_services
        @services = policy_scope(Product).where(:linetype => 1).order(:item)
      end

      def set_service
        @service = Product.find(params[:id])
      end
      
      def set_categories
        @servicecategories = policy_scope(Productcategory).order(:text)
      end

      # Only allow a trusted parameter "white list" through.
      def service_params
        params.require(:product).permit(:company_id, :productcategory_id, :item, :quantity, :unit_id, :rate, :vat_id, :vat, :price, :total, :linetype)
      end
  end
end
