module Mjbook
  module ExpendsHelper
    def expend_expenses(expend_id)
      expense = Mjbook::Expense.joins(:expenditems).where('mjbook_expenditems.expend_id' => expend_id).first
      return expense.supplier.company_name
    end


    def expend_journal_entries(expend)
      journal_entries = policy_scope(Journal).joins(:expenditem).where('mjbook_expenditems.expend_id' => expend.id)
      if !journal_entries.blank?
        link_to '', journals_path(:expenditem_ids => journal_entries), class: ('line_journal_icon_show') , title: "show journal entry"
      end
    end


    def expenditem_journal_entry(item)
      journal_entry = policy_scope(Journal).where(:expenditem_id => item.id).first
      if journal_entry.blank?
        link_to '', new_journal_path(:expenditem_id => item.id), class: 'line_journal_add_icon_show' , title: "add journal entry"
      else
        link_to '', journal_path(journal_entry), class: ('line_journal_icon_show') , title: "show journal entry"
      end
    end


  end
end
