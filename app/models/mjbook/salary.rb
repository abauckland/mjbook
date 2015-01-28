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
  
      event :correct do
        transitions :from => :paid, :to => :accepted
      end
    end

    validates :user_id, presence: true 
    validates :total, presence: true, numericality: true
    validates :date,
      presence: true,
      format: { with: DATE_REGEXP, message: "please enter a valid date in the format dd/mm/yyyy" }

    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Employee", "Amount Paid", "Date"]
        all.each do |set|
          csv << [
                 set.user.name,
                 number_to_currency(set.total, :unit => "£"),
                 set.date.strftime("%d/%m/%y")
                  ]

        end
      end
    end


    private

    default_scope { order('date DESC') }

  end
end
