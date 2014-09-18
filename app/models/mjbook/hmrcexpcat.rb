module Mjbook
  class Hmrcexpcat < ActiveRecord::Base
    
    has_many :mileages
    has_many :expenses 
       
  end
end
