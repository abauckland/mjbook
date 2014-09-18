module Mjbook
  class Expenditure < ActiveRecord::Base
    
    belongs_to :expenseexpend        
    belongs_to :user
    
    
  end
end
