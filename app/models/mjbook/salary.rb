module Mjbook
  class Salary < ActiveRecord::Base

    include AASM

    belongs_to :company
    belongs_to :user
    has_many :expenditems

    aasm :column => 'state' do

      state :submitted, :initial => true 
      state :rejected
      state :accepted
      state :paid
  
      event :accept do
        transitions :from => :submitted, :to => :accepted
        transitions :from => :rejected, :to => :accepted
      end
  
      event :reject do
        transitions :from => :submitted, :to => :rejected
        transitions :from => :accepted, :to => :rejected
      end
  
      event :pay do
        transitions :from => :accepted, :to => :paid
      end
  
      event :correct_payment do
        transitions :from => :paid, :to => :accepted
      end
    end  

    validates :user_id, presence: true 
    validates :total, presence: true, numericality: true
    validates :date,
      presence: true,
      format: { with: DATE_REGEXP, message: "please enter a valid date in the format dd/mm/yyyy" }    
          
  end
end
