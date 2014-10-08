require_dependency "mjbook/application_controller"

module Mjbook
  class RatesController < ApplicationController
    before_action :set_rates, only: [:index]
    before_action :set_rate, only: [:show, :edit, :update, :destroy]

    # GET /rates
    def index
    end
    
    def list_rates
#need to add category filter
      @rates = Rate.where(:company_id => current_user.company_id).order(:item)
      render :json => @rates      
    end

    # GET /rates/new
    def new
      @rate = rate.new
    end

    # GET /rates/1/edit
    def edit
    end

    # POST /rates
    def create
      @rate = Rate.new(rate_params)
      #calculate cost field for rate
      vat = Mjbook::VAT.where(:id => rate_params[:vat_id]).first      
      @rate.cost = rate_params[:price]*(1/vat.rate)

      if @rate.save
        redirect_to @rate, notice: 'rate was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /rates/1
    def update      
      if @rate.update(rate_params)

        #calculate cost field for rate and update
        vat = Mjbook::VAT.where(:id => rate_params[:vat_id]).first      
        cost = rate_params[:price]*(1/vat.rate)
        @rate.update(:cost => cost)        
        
        redirect_to @rate, notice: 'rate was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /rates/1
    def destroy
      @rate.destroy
      redirect_to rates_url, notice: 'rate was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_rates
        @rates = Rate.where(:company_id => current_user.company_id).order(:item)
      end

      def set_rate
        @rate = Rate.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def rate_params
        params.require(:rate).permit(:company_id, :ratecategory_id, :item, :quantity, :unit_id, :cost, :vat_id, :vat, :price)
      end
  end
end
