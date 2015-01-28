module Mjbook
  class Payment < ActiveRecord::Base

    include AASM

    belongs_to :companyaccount
    belongs_to :paymethod
    belongs_to :company
    belongs_to :user
    has_many :paymentitems, :dependent => :destroy
    has_many :summaries

    enum inc_type: [:invoice, :transfer, :misc]
        
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

    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Ref", "Invoice Ref", "Paid Into", "Date", "Price", "VAT", "Total", "Notes"]
        all.each do |set|
          csv << [
                  set.ref,
                  set.invoice.ref,
                  set.paymethod.text,
                  set.companyaccount.name,
                  set.date.strftime("%d/%m/%y"),
                  number_to_currency(set.price, :unit => "£"),
                  number_to_currency(set.vat_due, :unit => "£"),
                  number_to_currency(set.total, :unit => "£"),
                  set.note
                  ]

        end
      end
    end

    private

    default_scope { order('date DESC') }

  end
end
