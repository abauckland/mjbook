module Mjbook
  class Expense < ActiveRecord::Base
    
    belongs_to :hmrcexpcat
    belongs_to :project
    belongs_to :expenseexpend
    belongs_to :supplier
    belongs_to :user      
      
    mount_uploader :receipt, LogoUploader
    
  end
end
