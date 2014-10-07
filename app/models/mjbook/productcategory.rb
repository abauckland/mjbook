module Mjbook
  class Productcategory < ActiveRecord::Base
    has_many :products
    belongs_to :company

    validates :name, presence: true

  end
end
