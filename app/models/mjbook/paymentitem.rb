module Mjbook
  class Paymentitem < ActiveRecord::Base

    belongs_to :payment
    belongs_to :inline
    belongs_to :transfer
#    belongs_to :donation
    belongs_to :misincome
    
  end
end
