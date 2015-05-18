module Mjbook
  module PaymentsHelper
    
    def payment_invoice_details(payment)
      invoice = Invoice.joins(:ingroups => [:inlines => :paymentitems]).where('mjbook_paymentitems.payment_id' => payment.id).first
      if invoice
        "<td class='payment_invoice'>#{invoice.ref}</td><td class='payment_invoice'>#{invoice.date}</td>".html_safe
      else
        "<td class='payment_invoice'>n/a</td><td class='payment_invoice'>n/a</td>".html_safe
      end
    end

    def group_info(group)
      unless group.inlines.due.blank?
        "<div class='group_info'><p>#{ group.ref } #{ group.text }</p></div>".html_safe
      end
    end
         
  end
end
