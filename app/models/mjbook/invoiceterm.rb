module Mjbook
  class Invoiceterm < ActiveRecord::Base
    has_many :invoices
    
    validates :ref, :terms, presence: true     
    validates :period, presence: true, numericality: true
    
  end
end
