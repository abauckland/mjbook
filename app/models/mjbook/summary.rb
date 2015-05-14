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



    private

    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Date", "Ref", "Type", "Status", "Credit", "Debit", "Balance"]
        all.each do |set|

          if set.expend_id?
            ref_array =  [set.expend.ref, set.expend.exp_type, set.expend.state]
          end
  
          if set.payment_id?
            ref_array =  [set.payment.ref, set.payment.inc_type, set.payment.state]
          end
  
          if set.transfer_id?
            ref_array =  ["", "Transfer", set.transfer.state]
          end

          csv << [
                  set.date.strftime("%d/%m/%y"),
                  ref_array,
                  set.amount_in,
                  set.amount_out,
                  set.balance
                  ]
        end
      end
    end

      default_scope { order('date ASC') }
  end
end
