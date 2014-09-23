module Mjbook
  class Mileagemode < ActiveRecord::Base
        has_many :mileages
        belongs_to :company
        
        
        
        
  end
end
