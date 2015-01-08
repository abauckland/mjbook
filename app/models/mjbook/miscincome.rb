module Mjbook
  class Miscincome < ActiveRecord::Base

    include AASM

    belongs_to :project
    belongs_to :customer
    belongs_to :company

    has_many :paymentitems

    aasm :column => 'state' do

      state :submitted, :initial => true 
      state :paid

      event :paid do
        transitions :from => :submitted, :to => :paid
      end
  
      event :correct_transfer do
        transitions :from => :paid, :to => :submitted
      end
    end  

  end
end
