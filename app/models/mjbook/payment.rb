module Mjbook
  class Payment < ActiveRecord::Base

    include AASM
    
    belongs_to :invoice
    belongs_to :project
 #   enum status: [:paid, :reconciled]
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
