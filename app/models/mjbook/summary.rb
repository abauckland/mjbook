module Mjbook
  class Summary < ActiveRecord::Base
    
    belongs_to :company
    belongs_to :companyaccount
    belongs_to :expend
    belongs_to :payment

    scope :subsequent_transactions, ->(date) {where('date > ?', date)}

    scope :subsequent_account_transactions, ->(account_id, date) {where(:companyaccount_id => account_id
                                                                       ).where('date > ?', date)
                                                                 }

  end
end
