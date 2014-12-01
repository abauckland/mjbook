module Mjbook
  class Expend < ActiveRecord::Base

    include AASM
        
    belongs_to :companyaccount
    belongs_to :paymethod
    belongs_to :user
    has_many :expenditems, :dependent => :destroy
    
#    enum exp_status: [:paid, :reconciled]
    enum exp_type: [:business, :personal, :salary, :transfer]


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

    validates :paymethod_id, :companyaccount_id, presence: true
    validates :date,
      presence: true,
      format: { with: DATE_REGEXP, message: "please enter a valid date in the format dd/mm/yyyy" }
    
  end
end
