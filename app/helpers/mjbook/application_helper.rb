module Mjbook
  module ApplicationHelper
    
    def error_check(object, key)
       if !object.errors[key].blank?
       "<t style='color: #ff0000'>#{object.errors[key][0]}</t>".html_safe
      end       
    end
    
    def pounds(price)
      number_to_currency(price, :unit => "£")
    end


    def row_show_link(model, display)
      link_to '', polymorphic_url(model), class: ('line_show_icon_' << display) , title: "show full details"     
    end 

    def row_edit_link(model, display)
      link_to '', edit_polymorphic_url(model), method: :delete, class: ('line_edit_icon_' << display) , title: "edit"     
    end    

    def row_delete_link(model, display)
      link_to '', polymorphic_url(model), method: :delete, class: ('line_delete_icon_' << display) , title: "delete"     
    end

    def row_reject_link(model, display)
      link_to '', polymorphic_path([:reject, model]), :method => :get,  :remote => true, class: ('line_reject_icon_' << display) , title: "mark as rejected"     
    end

    def row_accept_link(model, display)
      link_to '', polymorphic_path([:accept, model]), :method => :get,  :remote => true, class: ('line_accept_icon_' << display) , title: "mark as accepted"     
    end
    
    def row_print_link(model, display)
      link_to '', polymorphic_path([:print, model]), class: ('line_pdf_icon_' << display) , title: "print pdf"     
    end        

    def row_reconcile_link(model, display)
      link_to '', polymorphic_path([:reconcile, model]), class: ('line_reconcile_icon_' << display) , title: "mark as reconciled"     
    end 
    
  end
end