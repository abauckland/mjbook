require_dependency "mjbook/application_controller"

module Mjbook
  class SettingsController < ApplicationController

    def new
      @setting = Setting.new
    end

    # GET /settings/1/edit
    def edit
      @setting = Setting.where(:company_id => params[:id]).first
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
      @setting = Setting.where(:id => params[:id]).first
      authorize @setting
      if @setting.update(setting_params)
        redirect_to edit_setting_path(@setting, :id => @setting.company_id), notice: 'Setting was successfully updated.'
      else
        render :edit, :id => @setting.company_id
      end
    end


    private
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
