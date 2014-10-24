module Mjbook
  class Quoteterm < ActiveRecord::Base
    has_many :quotes

    validates :ref, presence: true    
    validates :period, presence: true, numericality: true
    validates :terms, presence: true 

  end
end
