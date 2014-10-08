module Mjbook
  class Hmrcexpcat < ActiveRecord::Base

    belongs_to :company    
    
    has_many :mileages
    has_many :expenses 
       
  end
end
