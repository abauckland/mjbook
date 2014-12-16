module Mjbook
  class Inline < ActiveRecord::Base

    include AASM

    belongs_to :ingroup
    belongs_to :unit
    belongs_to :vat
    has_many :paymentitems
    has_many :creditnoteitems
    has_many :writeoffitems
    
    aasm :column => 'state' do

      state :due, :initial => true
      state :paid
  
      event :pay do
        transitions :from => :due, :to => :paid
      end
      
      event :rescind do
        transitions :from => :paid, :to => :due
      end

    end


    default_scope { order('line_order ASC') }
    
  end
end
