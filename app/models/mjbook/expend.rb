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
        csv << ["Ref", "Employee", "Supplier", "Payment Method", "Company Account", "Receipt", "Date", "Price", "VAT", "Total", "Note"]
        all.each do |set|
          csv << [
                 set.ref,
                 set.user.name,
                 set.expense.supplier.company_name,
                 set.paymethod.method,
                 set.companyaccount.name,
                 set..expend_receipt,
                 set.date.strftime("%d/%m/%y"),
                 number_to_currency(set.price, :unit => "£"),
                 number_to_currency(set.vat, :unit => "£"),
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
