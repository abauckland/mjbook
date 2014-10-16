module Mjbook
  class Invoiceterm < ActiveRecord::Base
    has_many :invoices
    
    validates :period, presence: true, numericality: true
    validates :terms, presence: true 
    
  end
end
