module Mjbook
  class Expend < ActiveRecord::Base
    
    belongs_to :companyaccount
    belongs_to :paymethod
    belongs_to :user
    belongs_to :expense
    
    enum status: [:paid, :reconciled]
    enum exp_type: [:business, :personal, :salary]
    
  end
end
