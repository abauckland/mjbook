require_dependency "mjbook/application_controller"

module Mjbook
  class MileagemodesController < ApplicationController
    before_action :set_mileagemode, only: [:update]

    # GET /mileagemodes/1/edit
    def edit
      @mileagemodes = policy_scope(Mileagemode)
    end

    # PATCH/PUT /mileagemodes/1
    def update
      authorize @mileagemode
      if @mileagemode.update(mileagemode_params)
        check_mileage = Mjbook::Mileagemode.where(:company_id => 1, :rate => 0).first
        if check_mileage
          redirect_to summaries_path, notice: 'Mileagemode was successfully updated, not all have been completed though.'
        else
          redirect_to edit_mileagemode_path(current_user.company_id), notice: 'Mileagemode was successfully updated.'
        end
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
