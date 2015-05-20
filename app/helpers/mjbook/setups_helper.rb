module Mjbook
  module SetupsHelper

    def check_email(current_user)
      company_setting = Mjbook::Setting.where(:company_id => current_user.company_id).first
      unless company_setting
        "<li>Add email settings</li><li>Add account year start date</li>".html_safe
      end
    end

    def check_account(current_user)
      accounts_exist = Mjbook::Companyaccount.where(:company_id => 1).first
      unless accounts_exist
        "<li>Add bank or cash account for company</li>".html_safe
      end
    end

    def check_mileage(current_user)
      check_mileage = Mjbook::Mileagemode.where(:company_id => 1, :rate => 0).first
      if check_mileage
        "<li>Set mileage rates for business expenses</li>".html_safe
      end
    end


    def link_action(current_user)
      company_setting = Mjbook::Setting.where(:company_id => current_user.company_id).first
      accounts_exist = Mjbook::Companyaccount.where(:company_id => current_user.company_id).first
      if company_setting.blank?
        link_to "continue", new_setting_path, class: "left_edit_button"
      elsif accounts_exist.blank?
        link_to "continue", new_companyaccount_path, class: "left_edit_button"
      else
        link_to "continue", edit_mileagemode_path(current_user.company_id), class: "left_edit_button"
      end
    end

  end
end
