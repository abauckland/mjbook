module Mjbook
  class Expense < ActiveRecord::Base
    
    belongs_to :hmrcexpcat
    belongs_to :project
    belongs_to :expenseexpend
    belongs_to :supplier
    belongs_to :user      
    belongs_to :company
    belongs_to :mileage
      
    mount_uploader :receipt, ReceiptUploader

    enum exp_type: [:business, :personal]
    enum status: [:submitted, :accepted, :rejected, :paid]


   # validates :project_id, presence: true
#    validates :supplier_id, presence: true
   # validates :hmrcexpcat_id, presence: true
   # validates :price, presence: true, numericality: true
  #  validates :vat, presence: true, numericality: true
 #   validates :total, presence: true, numericality: true
#    validates :date, presence: true
  
    scope :business, ->() { where(:exp_type => :business).uniq }
   
  end
end
