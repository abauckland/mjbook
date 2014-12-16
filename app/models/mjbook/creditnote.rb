module Mjbook
  class Creditnote < ActiveRecord::Base

    include AASM
    
    has_many :creditnoteitems, :dependent => :destroy
    belongs_to :company    

    aasm :column => 'state' do

      state :draft, :initial => true
      state :confirmed

      event :confirm do
        transitions :from => :draft, :to => :confirmed
      end
  
    end


  end
end
