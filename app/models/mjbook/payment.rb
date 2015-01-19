module Mjbook
  class Payment < ActiveRecord::Base

    include AASM

    belongs_to :companyaccount
    belongs_to :paymethod
    belongs_to :company
    belongs_to :user
    has_many :paymentitems, :dependent => :destroy
    has_many :summaries

    enum inc_type: [:invoice, :transfer, :misc]
        
    aasm :column => 'state' do

      state :paid, :initial => true
      state :confirmed
      state :reconciled

      event :confirm do
        transitions :from => :paid, :to => :confirmed
      end
  
      event :reconcile do
        transitions :from => :confirmed, :to => :reconciled
      end
  
      event :unreconcile do
        transitions :from => :reconciled, :to => :confirmed
      end
  
    end

    private

    default_scope { order('date DESC') }

  end
end
