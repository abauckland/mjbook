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

      event :correct do
        transitions :from => :paid, :to => :draft
      end
    end

    validates :project_id, presence: true
    validates :price, presence: true, numericality: true
    validates :vat, presence: true, numericality: true
    validates :total, presence: true, numericality: true
    validates :date, presence: true

    validate :total_sum

    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Reference","Job Reference", "Customer", "Price", "VAT", "Total", "Date", "State", "Notes"]
        all.each do |set|
          csv << [
                 set.ref,
                 set.project.ref,
                 set.project.customer.company_name,
                 set.price,
                 set.vat,
                 set.total,
                 set.date.strftime("%d/%m/%y"),
                 set.state,
                 set.notes
                 ]
        end
      end
    end

    private

    default_scope { order('date DESC') }

    def total_sum
      unless self.total == self.price + self.vat
        self.errors[:total_sum] << 'Price plus VAT does not equal total entered'
      end
    end

  end
end
