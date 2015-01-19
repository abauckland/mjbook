module Mjbook
  class Miscincome < ActiveRecord::Base

    include AASM

    belongs_to :project
    belongs_to :customer
    belongs_to :company

    has_many :paymentitems

    aasm :column => 'state' do

      state :draft, :initial => true
      state :paid

      event :pay do
        transitions :from => :draft, :to => :paid
      end

      event :correct_payment do
        transitions :from => :paid, :to => :draft
      end
    end

    private

    default_scope { order('date DESC') }

  end
end
