module Mjbook
  class Miscexpense < ActiveRecord::Base

    include AASM

    belongs_to :hmrcexpcat
    belongs_to :project
    belongs_to :supplier
    belongs_to :user
    belongs_to :company
    belongs_to :mileage, :dependent => :destroy

    has_many :expenditems

    mount_uploader :receipt, ReceiptUploader

    enum exp_type: [:business, :personal, :salary, :transfer, :misc]

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

  end
end
