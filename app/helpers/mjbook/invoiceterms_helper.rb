module Mjbook
  module InvoicetermsHelper
    
    def invoiceterm_in_use(invoiceterm)      
      term = Inovices.where(:invoiceterm_id => invoiceterm.id).first      
      if term.blank?
        true
      end
    end
      
    
  end
end
