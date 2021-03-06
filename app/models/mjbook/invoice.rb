module Mjbook
  class Invoice < ActiveRecord::Base

    include AASM

    has_many :ingroups, :dependent => :destroy

    belongs_to :project
    belongs_to :invoiceterm
    belongs_to :invoicetype

    accepts_nested_attributes_for :ingroups

#   after_create :create_nested_records

    aasm :column => 'state' do

      state :draft, :initial => true
      state :submitted
      state :part_paid
      state :paid

      event :submit do
        transitions :from => :draft, :to => :submitted
      end

      event :part_pay do
        transitions :from => :submitted, :to => :part_paid
        transitions :from => :part_paid, :to => :part_paid
      end

      event :pay do
        transitions :from => :submitted, :to => :paid
        transitions :from => :part_paid, :to => :paid
      end

      event :correct_payment do
        transitions :from => :paid, :to => :submitted
        transitions :from => :part_paid, :to => :submitted
      end

      event :correct_part_payment do
        transitions :from => :paid, :to => :part_paid
      end

    end

    validates :project_id, :invoiceterm_id, :invoicetype_id, :ref, presence: true
    validates :date,
      presence: true,
      format: { with: DATE_REGEXP, message: "please enter a valid date in the format dd/mm/yyyy" }


    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Invoice Ref", "Job Ref", "Invoice Type", "Cust. Ref", "Customer Name", "Customer Company", "Date", "Paid Into", "Date", "Price", "VAT", "Total", "Status"]
        all.each do |set|
          csv << [
                 set.ref,
                 set.project.ref,
                 set.invoicetype.text,
                 set.customer_ref,
                 set.project.customer.name,
                 set.project.customer.company_name,
                 set.date.strftime("%d/%m/%y"),
                 set.price,
                 set.vat_due,
                 set.total,
                 set.state
                 ]

        end
      end
    end

    private

    default_scope { order('date DESC') }

#    def create_nested_records
#      Mjbook::Ingroup.create(:invoice_id => self.id)
#    end

  end
end
