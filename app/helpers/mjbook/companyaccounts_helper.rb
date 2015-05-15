module Mjbook
  module CompanyaccountsHelper
    def companyaccount_in_use(companyaccount)
      expend = Expend.where(:companyaccount_id => companyaccount.id).first
      payment = Payment.where(:companyaccount_id => companyaccount.id).first
      if expend.blank? && payment.blank?
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
