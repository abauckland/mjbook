module Mjbook
  class Expend < ActiveRecord::Base

    include AASM

    belongs_to :companyaccount
    belongs_to :paymethod
    belongs_to :user
    has_many :expenditems, :dependent => :destroy
    has_many :summaries

#    enum exp_status: [:paid, :reconciled]
    enum exp_type: [:business, :personal, :salary, :transfer, :misc]


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
        csv << ["Ref", "Expenditure Type", "Expenditure Ref", "Payment Method", "Company Account", "Date", "Price", "VAT", "Total", "Receipt", "Status", "Note"]
        all.each do |set|

          if set.business?
            expend_ref = set.expenditem.expense.ref
          elsif set.personal?
            expend_ref = set.expenditem.expense.ref
          elsif set.salary?
            expend_ref = set.expenditem.salary.user.name
          elsif set.transfer?
            expend_ref = ""
          else set.misc?
            expend_ref = ""
          end

          if set.expend_receipt
            receipt_confirm = "yes"
          else
            receipt_confirm = ""
          end

          csv << [
                  set.ref,
                  set.exp_type,
                  expend_ref,
                  set.paymethod.text,
                  set.companyaccount.name,
                  set.date.strftime("%d/%m/%y"),
                  number_to_currency(set.price, :unit => "£"),
                  number_to_currency(set.vat_due, :unit => "£"),
                  number_to_currency(set.total, :unit => "£"),
                  receipt_confirm,
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
