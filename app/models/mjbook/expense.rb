module Mjbook
  class Expense < ActiveRecord::Base

    include AASM

    belongs_to :hmrcexpcat
    belongs_to :project
    belongs_to :supplier
    belongs_to :user
    belongs_to :company

    has_one :mileage, :dependent => :destroy
    has_many :expenditems

    accepts_nested_attributes_for :mileage


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

      event :resubmit do
        transitions :from => :rejected, :to => :submitted
      end

      event :correct do
        transitions :from => :paid, :to => :accepted
      end
    end

    before_validation :set_totals, on: [:create, :update], if: :mileage_record?


    validates :project_id, presence: true
    validates :hmrcexpcat_id, presence: true
    validates :supplier_id, presence: true, unless: :mileage_record?
    validates :price, presence: true, numericality: true
    validates :vat, presence: true, numericality: true
    validates :total, presence: true, numericality: true
    validates :date,
      presence: true,
      format: { with: DATE_REGEXP, message: "please enter a valid date in the format dd/mm/yyyy" }

    validate :total_sum

    scope :user, ->(current_user) {  joins(:project).where(:user_id => current_user.id, 'mjbook_projects.company_id' => current_user.company_id)}

    scope :business, ->() { where(:exp_type => 0).uniq }
    scope :personal, ->() { where(:exp_type => 1).uniq }
    scope :salary, ->() { where(:exp_type => 2).uniq }
    scope :transfer, ->() { where(:exp_type => 3).uniq }


    private

    def mileage_record?
      hmrcexpcat_id == 3 #business mileage
    end

    def set_totals
      mode = Mjbook::Mileagemode.find(mileage.mileagemode_id)
      self.price = mode.rate * self.mileage.distance
      self.vat = 0
      self.total = mode.rate * self.mileage.distance
    end

    def total_sum     
      total = self.price + self.vat
      unless self.total == total
        self.errors[:total_sum] << 'Price plus VAT does not equal total entered'
      end
    end


    default_scope { order(:date) }


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
