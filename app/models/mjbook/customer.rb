module Mjbook
  class Customer < ActiveRecord::Base
    #relationship with model in main app
    belongs_to :company
    
    has_many :projects
    
    validates_presence_of :surname
    
    def name
      return title+' '+first_name+' '+surname
    end
      
  end
end
