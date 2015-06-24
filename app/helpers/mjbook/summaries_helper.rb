module Mjbook
  module SummariesHelper

    def account_reconciled_check(account, date_to)
       #check if all transactions have been reconciled
       reconciled_check = policy_scope(Summary).where("date <= ? AND companyaccount_id = ?", date_to, account.id).where(:state => :unreconciled).first
       if reconciled_check.blank?
         "<td class='summary_credit reconciled'>#{pounds(account_balance(account))}</td>".html_safe
       else
         "<td class='summary_credit unreconciled'>#{pounds(account_balance(account))}</td>".html_safe
       end
     end

    def account_balance(account)
      #filter by id to get last change to account
      account = policy_scope(Summary).where(:companyaccount_id => account.id).order(:date, :id).last
      if account
        account.account_balance
      else
        return 0
      end
    end


    def journal_check(summary)

      if summary.payment_id?
        journal_entry = Journal.joins(:paymentitem => [:payment => :summary]
                              ).where('mjbook_summaries.id' => summary.id
                              ).first
        if journal_entry
          link_to '', payment_path(summary.payment_id), class: 'line_journal_icon_show' , title: "show journal entry"
        end
      end

      if summary.expend_id?
        journal_entry = Journal.joins(:expenditem => [:expend => :summary]
                              ).where('mjbook_summaries.id' => summary.id
                              ).first
        if journal_entry
          link_to '', expend_path(summary.expend_id), class: 'line_journal_icon_show' , title: "show journal entry"
        end
      end

    end

  end
end
