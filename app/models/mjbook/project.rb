module Mjbook
  class Project < ActiveRecord::Base
    #relationship with model in main app
    belongs_to :company
        
   
    has_many :mileages
    has_many :invoicemethods
    has_many :expenses
    
    has_many :quotes
    has_many :invoices

    belongs_to :customer

    validates_presence_of :ref
    validates_presence_of :title
    validates_presence_of :customer_id
    validates_presence_of :invoicemethod_id

    def name
      return ref+' '+title
    end    
  end
end
