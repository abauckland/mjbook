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


    def payment_journal_entries(payment)
      journal_entries = policy_scope(Journal).joins(:paymentitem).where('mjbook_paymentitems.payment_id' => payment.id)
      if !journal_entries.blank?
        link_to '', journals_path(:paymentitem_ids => journal_entries), method: :delete, class: ('line_edit_icon_show') , title: "show journal entry"
      end
    end


    def paymentitem_journal_entry(item)
      journal_entry = policy_scope(Journal).where(:paymentitem_id => item.id).first
      if !journal_entry.blank?
        link_to '', journal_path(journal_entry), method: :delete, class: ('line_edit_icon_show') , title: "show journal entry"
      end
    end

  end
end
