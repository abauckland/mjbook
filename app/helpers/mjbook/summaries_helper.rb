module Mjbook
  module SummariesHelper

    def account_balance(account)
      account = policy_scope(Summary).where(:companyaccount_id => account.id).order(:date).last
      if account
        account.account_balance
      else
        return 0
      end
    end

  end
end
