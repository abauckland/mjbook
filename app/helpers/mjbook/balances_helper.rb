module Mjbook
  module BalancesHelper
    
    def payment_journals_link(period)

      journal_entries = Journal.joins(:paymentitem => :payment
                               ).where('mjbook_payments.date' => period.year_start..(1.year.from_now(period.year_start))
                               ).where(:company_id => current_user.company_id
                               ).where.not(:paymentitem_id => nil)

      if !journal_entries.blank?
        link_to '', journals_path(:period => period.id, :transaction_type => 'Payments'), class: ('line_journal_icon_show') , title: "show journal entries"
      end
    end

    def expend_journals_link(period)

      journal_entries = Journal.joins(:expenditem => :expend
                               ).where('mjbook_expends.date' => period.year_start..(1.year.from_now(period.year_start))
                               ).where(:company_id => current_user.company_id
                               ).where.not(:expenditem_id => nil)

      journal_entries = policy_scope(Journal).where.not(:expenditem_id => nil)
      if !journal_entries.blank?
        link_to '', journals_path(:period => period.id, :transaction_type => 'Expenditures'), class: ('line_journal_icon_show') , title: "show journal entries"
      end
    end

  end
end
