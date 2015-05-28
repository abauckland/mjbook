module Mjbook
  class Expense < ActiveRecord::Base

    include AASM

    belongs_to :hmrcexpcat
    belongs_to :project
    belongs_to :supplier
    belongs_to :user
    belongs_to :company
    belongs_to :mileage, :dependent => :destroy

    has_many :expenditems

    mount_uploader :receipt, ReceiptUploader

    enum exp_type: [:business, :personal]
#    enum status: [:submitted, :rejected, :accepted, :paid]

    aasm :column => 'state' do

      state :submitted, :initial => true
      state :rejected
      state :accepted
      state :paid

      event :accept do
        transitions :from => :submitted, :to => :accepted
        transitions :from => :rejected, :to => :accepted
      end

      event :reject do
        transitions :from => :submitted, :to => :rejected
        transitions :from => :accepted, :to => :rejected
      end

      event :pay do
        transitions :from => :accepted, :to => :paid
      end

      event :correct do
        transitions :from => :paid, :to => :accepted
      end
    end


    validates :project_id, presence: true
    validates :supplier_id, presence: true
    validates :hmrcexpcat_id, presence: true
    validates :price, presence: true, numericality: true
    validates :vat, presence: true, numericality: true
    validates :total, presence: true, numericality: true
    validates :date, presence: true


    scope :user, ->(current_user) {  joins(:project).where(:user_id => current_user.id, 'mjbook_projects.company_id' => current_user.company_id)}

    scope :business, ->() { where(:exp_type => 0).uniq }
    scope :personal, ->() { where(:exp_type => 1).uniq }
    scope :salary, ->() { where(:exp_type => 2).uniq }
    scope :transfer, ->() { where(:exp_type => 3).uniq }

    private

#    default_scope { order('date DESC') }


    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Reference", "Expense Type", "Job Reference", "Expenditure Category", "Supplier", "Supplier Ref:", "Issued Date", "Due Date", "Mileage", "Price", "VAT", "Total", "Receipt", "Status"]
        all.each do |set|

          if !set.receipt.blank?
            receipt_confirm = "yes"
          else
            receipt_confirm = ""
          end

          if !set.mileage.blank?
            mileage_distance = set.mileage.distance.to_s
          else
            mileage_distance = ""
          end

          csv << [
                  set.ref,
                  set.exp_type,
                  set.project.ref,
                  set.hmrcexpcat.category,
                  set.supplier.company_name,
                  set.supplier_ref,
                  set.date.strftime("%d/%m/%y"),
                  set.due_date.strftime("%d/%m/%y"),
                  mileage_distance,
                  set.price,
                  set.vat,
                  set.total,
                  receipt_confirm,
                  set.state
                  ]

        end
      end
    end

  end
end
