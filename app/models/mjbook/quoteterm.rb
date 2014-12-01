module Mjbook
  class Quoteterm < ActiveRecord::Base
    has_many :quotes
        
    validates :ref, :terms, presence: true     
    validates :period, presence: true, numericality: true

  end
end
