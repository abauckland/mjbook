module Mjbook
  class Companyaccount < ActiveRecord::Base

    belongs_to :company
    has_many :expends
    has_many :payments
    has_many :transfers
    
    validates :name, presence: true,
      uniqueness: {:scope => [:company_id]}    

    def name=(text)
      super(text.downcase)
    end

    def provider=(text)
      super(text.downcase)
    end

  end
end
