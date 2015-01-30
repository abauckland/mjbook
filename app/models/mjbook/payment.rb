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
            income_ref = set.paymentitem.inline.ingroup.invoice.ref
          elsif set.transfer?
            income_ref = set.paymentitem.transfer.ref
          else
            income_ref = set.paymentitem.miscincome.ref
          end

          csv << [
                  set.ref,
<<<<<<< HEAD
                  set.inc_type,
                  income_ref,
=======
                  payment_invoice(set),
>>>>>>> d2e8a2a007bc01e123c4319a7632df214f34f5b8
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

    def payment_invoice(set)
      invoice = Mjbook::Invoice.joins(:ingroups => [:inlines => :paymentitems]).where('mjbook_paymentitems.payment_id' => set.id).first
      if invoice
        invoice.ref
      end
    end

    private

    default_scope { order('date DESC') }

  end
end
