module Mjbook
  class Invoiceterm < ActiveRecord::Base
    has_many :invoices
    
    validates :ref, :terms, presence: true     
    validates :period, presence: true, numericality: true

    private

      default_scope { order('period ASC') }

  end
end
