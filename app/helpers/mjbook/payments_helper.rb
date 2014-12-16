module Mjbook
  module PaymentsHelper
    
    def payment_invoice(payment)
      invoice = Invoice.joins(:ingroups => [:inlines => :paymentitems]).where('mjbook_paymentitems.payment_id' => payment.id).first
      if invoice
        invoice.ref
      end
    end
         
    def group_info(group)
      unless group.inlines.due.blank?
        "<div class='group_info'><p>#{ group.ref } #{ group.text }</p></div>".html_safe
      end
    end
         
  end
end
