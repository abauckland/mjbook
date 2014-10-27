module Mjbook
  class Companyaccount < ActiveRecord::Base

    belongs_to :company    
    
    has_many :expends
    
    has_many :transfers
    
    validates_presence_of :name

  end
end
