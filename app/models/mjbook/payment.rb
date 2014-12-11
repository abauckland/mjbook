module Mjbook
  class Payment < ActiveRecord::Base

    include AASM

    belongs_to :companyaccount
    belongs_to :paymethod
    belongs_to :user    
    has_many :paymentitems, :dependent => :destroy

    enum inc_type: [:invoice, :transfer]
        
    aasm :column => 'state' do

      state :paid, :initial => true
      state :reconciled
  
      event :reconcile do
        transitions :from => :paid, :to => :reconciled
      end
  
      event :unreconcile do
        transitions :from => :reconciled, :to => :paid
      end
  
    end
    
  end
end
