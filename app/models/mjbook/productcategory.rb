module Mjbook
  class Productcategory < ActiveRecord::Base
    has_many :products
    belongs_to :company

    validates :text, presence: true, uniqueness: true

  end
end
