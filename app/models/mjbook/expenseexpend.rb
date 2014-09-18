module Mjbook
  class Expenseexpend < ActiveRecord::Base
    
    has_many :expenses
    has_many :expenditures
    belongs_to :user

  end
end
