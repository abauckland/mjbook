module Mjbook
  class Companyaccount < ActiveRecord::Base

    belongs_to :company
    has_many :expends
    has_many :payments
    has_many :transfers
    has_many :summaries

    validates :name, presence: true,
      uniqueness: {:scope => [:company_id]}    

    def name=(text)
      super(text.downcase)
    end

    def provider=(text)
      super(text.downcase)
    end

    private

    default_scope { order('name ASC') }

  end
end
