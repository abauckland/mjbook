module Mjbook
  class Productcategory < ActiveRecord::Base
    has_many :products
    belongs_to :company

    validates :text, presence: true, uniqueness: {:scope => [:company_id]}

    private

      default_scope { order('text ASC') }

  end
end
