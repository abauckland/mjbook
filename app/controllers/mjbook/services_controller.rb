require_dependency "mjbook/application_controller"

module Mjbook
  class ServicesController < ApplicationController
    before_action :set_services, only: [:index]
    before_action :set_service, only: [:show, :edit, :update, :destroy]

    # GET /services
    def index
    end
    
    def list_services
#need to add category filter
      @services = Service.where(:company_id => current_user.company_id).order(:item)
      render :json => @services      
    end

    # GET /services/new
    def new
      @service = Service.new
    end

    # GET /services/1/edit
    def edit
    end

    # POST /services
    def create
      @service = Service.new(service_params)
      #calculate cost field for service
      vat = Mjbook::VAT.where(:id => service_params[:vat_id]).first      
      @service.cost = service_params[:price]*(1/vat.rate)

      if @service.save
        redirect_to @service, notice: 'service was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /services/1
    def update      
      if @service.update(service_params)

        #calculate cost field for service and update
        vat = Mjbook::VAT.where(:id => service_params[:vat_id]).first      
        cost = service_params[:price]*(1/vat.rate)
        @service.update(:cost => cost)        
        
        redirect_to @service, notice: 'service was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /services/1
    def destroy
      @service.destroy
      redirect_to services_url, notice: 'service was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_services
        @services = Service.where(:company_id => current_user.company_id).order(:item)
      end

      def set_service
        @service = Service.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def service_params
        params.require(:service).permit(:company_id, :servicecategory_id, :item, :quantity, :unit_id, :cost, :vat_id, :vat, :price)
      end
  end
end
