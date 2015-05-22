module Mjbook
  class Journal < ActiveRecord::Base
    belongs_to :period
    belongs_to :paymentitem
    belongs_to :expenditem
    belongs_to :company

    validates :adjustment, presence: true, numericality: true
    validates :period_id, presence: true

    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Ref", "Date", "Inv. Ref", "Misc. Income Ref", "Expenditure Ref", "Item Amount", "Adjustment", "Allocated From", "Allocated To", "Notes"]
        all.each do |set|

                        if set.paymentitem_id?
                            ref = set.paymentitem.payment.ref
                            date = set.paymentitem.payment.date.strftime("%d/%m/%y")

                            if set.paymentitem.inline_id?
                               inv_ref = set.paymentitem.inline.invoice.ref
                               misc_ref = ""
                               exp_ref = ""
                               amount = pounds(set.paymentitem.inline.total)
                            end

                            if set.paymentitem.miscincome_id?
                               inv_ref = ""
                               misc_ref = set.paymentitem.miscincome.ref
                               exp_ref = ""
                               amount = pounds(set.paymentitem.miscincome.total)
                            end
                        end


                        if set.expenditem_id?
                            ref = set.expenditem.expend.ref
                            date = set.expenditem.payment.date.strftime("%d/%m/%y")

                            if set.expenditem.inline_id?
                               inv_ref = "",
                               misc_ref = "",
                               exp_ref = set.expenditem.inline.expense.ref
                               amount = pounds(set.expenditem.expense.total)
                            end
                        end

                        adjustment = pounds(set.adjustment),

                        if set.paymentitem_id?
                            allocated_from = original_payment_period(set.paymentitem_id)
                        else
                            allocated_from = original_expend_period(set.expenditem_id)
                        end

                        allocated_t = set.period.period
                        note = set.note

          csv << [
                  ref,
                  date,
                  inv_ref,
                  misc_ref,
                  exp_ref,
                  amount,
                  adjustment,
                  allocated_from,
                  allocated_to,
                  note
                  ]
        end
      end
    end


  end
end
