module Mjbook
  class Invoiceterm < ActiveRecord::Base
    has_many :invoices
    
    validates :ref, presence: true     
    validates :period, presence: true, numericality: true
    validates :terms, presence: true 
    
  end
end
