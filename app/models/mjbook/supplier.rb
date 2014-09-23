module Mjbook
  class Supplier < ActiveRecord::Base
    #relationship with model in main app
    belongs_to :company
        
    has_many :expenses
    
    validates_presence_of :company_name   

    def name
      return title+' '+first_name+' '+surname
    end

    
  end
end
