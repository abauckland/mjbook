module Mjbook
  class Transfer < ActiveRecord::Base
    
    include AASM
        
    belongs_to :account_from, :class_name => 'Companyaccount', :foreign_key => 'account_from_id'
    belongs_to :account_to, :class_name => 'Companyaccount', :foreign_key => 'account_to_id'
    belongs_to :paymethod
    has_many :expenditems
    has_many :paymentitems
    
    aasm :column => 'state' do

      state :drafted, :initial => true 
      state :transferred

      event :transfer do
        transitions :from => :drafted, :to => :transferred
      end
  
      event :correct do
        transitions :from => :transferred, :to => :drafted
      end
    end  

    validates :account_from_id, :account_to_id, :paymethod_id, presence: true
    validates :total, presence: true, numericality: true
    validates :date,
      presence: true,
      format: { with: DATE_REGEXP, message: "please enter a valid date in the format dd/mm/yyyy" }

    private

    default_scope { order('date DESC') }

  end
end
