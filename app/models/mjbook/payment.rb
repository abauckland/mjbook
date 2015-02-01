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
        csv << ["Ref", "Income Type", "Income Ref", "Payment Method", "Paid Into", "Date", "Price", "VAT", "Total", "State", "Notes"]
        all.each do |set|

          if set.invoice?
            income_ref = set.paymentitems.inline.ingroup.invoice.ref
          elsif set.transfer?
            income_ref = set.paymentitems.transfer.ref
          else
            income_ref = set.paymentitems.miscincome.ref
          end

          csv << [
                  set.ref,
                  set.inc_type,
                  income_ref,
                  set.paymethod.text,
                  set.companyaccount.name,
                  set.date.strftime("%d/%m/%y"),
                  number_to_currency(set.price, :unit => "£"),
                  number_to_currency(set.vat_due, :unit => "£"),
                  number_to_currency(set.total, :unit => "£"),
                  set.state,
                  set.note
                  ]
        end
      end
    end


    private

    default_scope { order('date DESC') }

  end
end
