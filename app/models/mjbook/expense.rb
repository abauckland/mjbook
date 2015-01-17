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

    enum exp_type: [:business, :personal, :salary, :transfer]
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


   # validates :project_id, presence: true
#    validates :supplier_id, presence: true
   # validates :hmrcexpcat_id, presence: true
   # validates :price, presence: true, numericality: true
  #  validates :vat, presence: true, numericality: true
 #   validates :total, presence: true, numericality: true
#    validates :date, presence: true

    scope :user, ->(current_user) {  joins(:project).where(:user_id => current_user.id, 'mjbook_projects.company_id' => current_user.company_id)}
    scope :company, ->(current_user) { joins(:project).where('mjbook_projects.company_id' => current_user.company_id)}
  
    scope :business, ->() { where(:exp_type => :business).uniq }
    scope :personal, ->() { where(:exp_type => :personal).uniq }
    scope :salary, ->() { where(:exp_type => :salary).uniq }
    scope :transfer, ->() { where(:exp_type => :transfer).uniq }
    
  end
end
