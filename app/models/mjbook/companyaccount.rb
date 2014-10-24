module Mjbook
  class Companyaccount < ActiveRecord::Base

    belongs_to :company    
    
    has_many :expenses
    
    validates_presence_of :name

  end
end
