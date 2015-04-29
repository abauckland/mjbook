require_dependency "mjbook/application_controller"

module Mjbook
  class SettingsController < ApplicationController
    before_action :set_setting, only: [:edit, :update] 


    def new
      @setting = Setting.new
    end

    # GET /settings/1/edit
    def edit
      authorize @setting
    end


    def create
      @setting = Setting.new(setting_params)
      authorize @setting
      if @setting.save
        add_period_record(@setting.year_start)
        redirect_to new_companyaccount_path, notice: 'Settings were successfully created.'
      else
        render :new
      end
    end


    # PATCH/PUT /settings/1
    def update
      authorize @setting
      if @setting.update(setting_params)
        
        redirect_to edit_setting_path(@setting), notice: 'Setting was successfully updated.'
      else
        render :edit
      end
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_setting
        @setting = Setting.where(:company_id => params[:id]).first
      end

      # Only allow a trusted parameter "white list" through.
      def setting_params
        params.require(:setting).permit(:company_id, :email_domain, :email_username, :email_password, :year_start)
      end

      def add_period_record(start_date)
           start_year = start_date.strftime("%Y")
          end_year = 1.year.from_now(start_date).strftime("%Y")
          period_name = start_year + "/" + end_year
        
        period = Period.create(:company_id => current_user.company_id,
                               :period => period_name,
                               :year_start => start_date,
                               :retained => 0
                               )
      end

  end
end
