require_dependency "mjbook/application_controller"

module Mjbook
  class MileagemodesController < ApplicationController
    before_action :set_mileagemode, only: [:show, :edit, :update, :destroy]

    # GET /mileagemodes/1/edit
    def edit
    end

    # POST /mileagemodes
    def create
      @mileagemode = Mileagemode.new(mileagemode_params)

      if @mileagemode.save
        redirect_to @mileagemode, notice: 'Mileagemode was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /mileagemodes/1
    def update
      if @mileagemode.update(mileagemode_params)
        redirect_to @mileagemode, notice: 'Mileagemode was successfully updated.'
      else
        render :edit
      end
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_mileagemode
        @mileagemode = Mileagemode.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def mileagemode_params
        params.require(:mileagemode).permit(:company_id, :mode, :rate, :hmrc_rate)
      end
  end
end
