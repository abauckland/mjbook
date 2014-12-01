module Mjbook
  class Productcategory < ActiveRecord::Base
    has_many :products
    belongs_to :company

    validates :text, presence: true, uniqueness: {:scope => [:company_id]}

    def text=(text)
      super(text.downcase)
    end

  end
end
