module Mjbook
  class Project < ActiveRecord::Base
    
    has_many :mileages
    has_many :invoicemethods
    has_many :expenses

    belongs_to :customers
    belongs_to :company
    
  end
end
