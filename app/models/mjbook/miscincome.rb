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


    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Reference","Job Reference", "Customer", "Price", "VAT", "Total", "Date", "State", "Notes"]
        all.each do |set|
          csv << [
                 set.ref,
                 set.project.ref,
                 set.project.customer.company_name,
                 number_to_currency(set.price, :unit => "£"),
                 number_to_currency(set.vat, :unit => "£"),
                 number_to_currency(set.total, :unit => "£"),
                 set.date.strftime("%d/%m/%y"),
                 set.state,
                 set.notes
                 ]
        end
      end
    end

    private

    default_scope { order('date DESC') }

  end
end
