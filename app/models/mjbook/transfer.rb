module Mjbook
  class Transfer < ActiveRecord::Base
    
    belongs_to :account_from, :class_name => 'Companyaccount', :foreign_key => 'account_from_id'
    belongs_to :account_to, :class_name => 'Companyaccount', :foreign_key => 'account_to_id'

    enum status: [:transfered, :reconciled]

    validates :account_from_id, presence: true
    validates :account_to_id, presence: true
    validates :total, presence: true, numericality: true
    validates :date, presence: true


    
  end
end
