module Mjbook
  module CustomersHelper
    
    def customer_in_use(customer)      
      customer = Project.where(:customer_id => customer.id).first      
      if customer.blank?
        true
      end  
    end
         
  end
end
