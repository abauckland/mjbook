module Mjbook
  module ApplicationHelper

    def menu_filter
        #redirect if the year_start date (and hence accounting period) have not been set
        #redirect if no company accounts have been set up for the company
        company_setting = Mjbook::Setting.where(:company_id => current_user.company_id).first
        account_exist = Mjbook::Companyaccount.where(:company_id => current_user.company_id).first
        #mileage settings
        unless company_setting && account_exist
          false
        else
          true
        end
    end


    def error_check(object, key)
       if !object.errors[key].blank?
       "<t style='color: #ff0000'>#{object.errors[key][0]}</t>".html_safe
      end
    end

    def pounds(price)
      number_to_currency(price, :unit => "£")
    end

    def pounds_no_unit(price)
      number_to_currency(price, :unit => "")
    end

    def row_show_link(model, display)
      link_to '', polymorphic_url(model), class: ('line_show_icon_' << display) , title: "show full details"
    end

    def row_edit_link(model, display)
      link_to '', edit_polymorphic_url(model), class: ('line_edit_icon_' << display) , title: "edit"
    end

    def row_delete_link(model, display)
      link_to '', polymorphic_url(model), method: :delete, class: ('line_delete_icon_' << display) , title: "delete"
    end

    def row_reject_link(model, display)
      link_to '', polymorphic_path([:reject, model]), :method => :get, :remote => true, class: ('line_reject_icon_' << display) , title: "reject"
    end

    def row_accept_link(model, display)
      link_to '', polymorphic_path([:accept, model]), :method => :get, :remote => true, class: ('line_accept_icon_' << display) , title: "accept"
    end

    def row_print_link(model, display)
      link_to '', polymorphic_path([:print, model]), class: ('line_pdf_icon_' << display) , title: "print pdf"
    end

    def row_reconcile_link(model, display)
      link_to '', polymorphic_path([:reconcile, model]), :method => :get, :remote => true, class: ('line_reconcile_icon_' << display) , title: "mark as reconciled"
    end

    def row_unreconcile_link(model, display)
      link_to '', polymorphic_path([:unreconcile, model]), :method => :get, :remote => true, class: ('line_unreconcile_icon_' << display) , title: "mark as unreconciled"
    end

    def row_pay_link(model, display)
      link_to '', polymorphic_path([:pay, model]), class: ('line_payment_icon_' << display) , title: "repayment"
    end

    def row_email_link(model, display)
      link_to '', polymorphic_path([:email, model]), :method => :get, :remote => true, class: ('line_email_icon_' << display) , title: "email to customer"
    end

    def row_transfer_link(model, display)
      link_to '', polymorphic_path([:process_transfer, model]), class: ('line_payment_icon_' << display) , title: "record transfer"
    end

  end
end