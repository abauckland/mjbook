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

  end
end
