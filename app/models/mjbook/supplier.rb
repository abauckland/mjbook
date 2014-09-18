module Mjbook
  class Supplier < ActiveRecord::Base
    
    has_many :expenses
    belongs_to :company

    def name
      return title+' '+first_name+' '+surname
    end

    
  end
end
