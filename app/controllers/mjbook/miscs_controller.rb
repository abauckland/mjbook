require_dependency "mjbook/application_controller"

module Mjbook
  class MiscsController < ApplicationController
    before_action :set_miscs, only: [:index]
    before_action :set_misc, only: [:show, :edit, :update, :destroy]

    # GET /miscs
    def index
    end
    
    def list_miscs
#need to add category filter
      @miscs = Misc.where(:company_id => current_user.company_id).order(:item)
      render :json => @miscs      
    end

    # GET /miscs/new
    def new
      @misc = misc.new
    end

    # GET /miscs/1/edit
    def edit
    end

    # POST /miscs
    def create
      @misc = Misc.new(misc_params)
      #calculate cost field for misc
      vat = Mjbook::VAT.where(:id => misc_params[:vat_id]).first      
      @misc.cost = misc_params[:price]*(1/vat.rate)

      if @misc.save
        redirect_to @misc, notice: 'misc was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /miscs/1
    def update      
      if @misc.update(misc_params)

        #calculate cost field for misc and update
        vat = Mjbook::VAT.where(:id => misc_params[:vat_id]).first      
        cost = misc_params[:price]*(1/vat.rate)
        @misc.update(:cost => cost)        
        
        redirect_to @misc, notice: 'misc was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /miscs/1
    def destroy
      @misc.destroy
      redirect_to miscs_url, notice: 'misc was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_miscs
        @miscs = Misc.where(:company_id => current_user.company_id).order(:item)
      end

      def set_misc
        @misc = Misc.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def misc_params
        params.require(:misc).permit(:company_id, :misccategory_id, :item, :quantity, :unit_id, :cost, :vat_id, :vat, :price)
      end
  end
end
