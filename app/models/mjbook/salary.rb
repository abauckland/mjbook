module Mjbook
  class Salary < ActiveRecord::Base

    belongs_to :company
    belongs_to :user

    enum status: [:submitted, :paid]
        
  end
end
