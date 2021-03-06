module Mjbook
  class Payment < ActiveRecord::Base

    include AASM

    belongs_to :companyaccount
    belongs_to :paymethod
    belongs_to :company
    belongs_to :user
    has_many :paymentitems, :dependent => :destroy
    has_one :summary

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

    validates :paymethod_id, :companyaccount_id, presence: true
    validates :date,
      presence: true,
      format: { with: DATE_REGEXP, message: "please enter a valid date in the format dd/mm/yyyy" }



    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Ref", "Income Type", "Income Ref", "Payment Method", "Paid Into", "Date", "Price", "VAT", "Total", "State", "Notes"]
        all.each do |set|

          invoice = Invoice.joins(:ingroups => [:inlines => :paymentitems]).where('mjbook_paymentitems.payment_id' => set.id).first

          if set.invoice?
            income_ref = invoice.ref
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
                  set.price,
                  set.vat,
                  set.total,
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
