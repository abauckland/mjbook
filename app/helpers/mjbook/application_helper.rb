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
    
    
  end
end
