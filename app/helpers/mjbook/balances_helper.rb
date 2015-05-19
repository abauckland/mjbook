module Mjbook
  module BalancesHelper
    
    def payment_journals_link
      journal_entries = policy_scope(Journal).where.not(:paymentitem_id => nil).ids
      if !journal_entries.blank?
        link_to '', journals_path(:paymentitem_ids => journal_entries), class: ('line_edit_icon_show') , title: "show journal entries"
      end
    end

    def expend_journals_link
      journal_entries = policy_scope(Journal).where.not(:expenditem_id => nil).ids
      if journal_entries.blank?
        link_to '', new_journal_path(:paymentitem_id => item.id), class: 'line_edit_icon_show' , title: "add journal entry"
      else
        link_to '', journals_path(:expenditem_ids => journal_entries), class: ('line_edit_icon_show') , title: "show journal entries"
      end
    end

  end
end
