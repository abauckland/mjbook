module Mjbook
  module SummariesHelper

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
