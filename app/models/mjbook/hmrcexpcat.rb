module Mjbook
  class Hmrcexpcat < ActiveRecord::Base

    belongs_to :company    
    belongs_to :hmrcgroup
    
    has_many :mileages
    has_many :expenses 

  end
end
