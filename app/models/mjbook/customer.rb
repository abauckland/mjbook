module Mjbook
  class Customer < ActiveRecord::Base

    has_many :projects
    belongs_to :company
    
    def name
      return title+' '+first_name+' '+surname
    end
      
  end
end
