module Mjbook
  class Expense < ActiveRecord::Base
    
    belongs_to :hmrcexpcat
    belongs_to :project
    belongs_to :expenseexpend
    belongs_to :supplier
    belongs_to :user      
      
    mount_uploader :receipt, ReceiptUploader

    validates_presence_of :project_id
    validates_presence_of :supplier_id
    validates_presence_of :hmrcexpcat_id
    validates_presence_of :amount
    validates_presence_of :issue_date
    
  end
end
