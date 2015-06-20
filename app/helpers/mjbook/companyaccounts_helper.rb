module Mjbook
  module CompanyaccountsHelper
    def companyaccount_in_use(companyaccount)
#      expend = Expend.where(:companyaccount_id => companyaccount.id).first
#      payment = Payment.where(:companyaccount_id => companyaccount.id).first
#      if expend.blank? && payment.blank?
#        true
#      end
#
#!!!above code does not check for transfers to an account
#if there is only one transaction on account
        account_transactions = policy_scope(Summary).where(:companyaccount_id => companyaccount.id)
        if account_transactions.count == 1
          true
        end
    end

    def companyaccount_cancel
      companyaccounts = policy_scope(Companyaccount).count
      if companyaccounts == 0
        link_to "cancel", balances_path
      else
        link_to "cancel", companyaccounts_path
      end
    end

  end
end
