module Mjbook
  module BalancesHelper
    
    def payment_journals_link
      journal_entries = policy_scope(Journal).where.not(:paymentitem_id => nil)
      if !journal_entries.blank?
        link_to '', journals_path(:paymentitems => true), class: ('line_journal_icon_show') , title: "show journal entries"
      end
    end

    def expend_journals_link
      journal_entries = policy_scope(Journal).where.not(:expenditem_id => nil)
      if !journal_entries.blank?
        link_to '', journals_path(:expenditems => true), class: ('line_journal_icon_show') , title: "show journal entries"
      end
    end

  end
end
