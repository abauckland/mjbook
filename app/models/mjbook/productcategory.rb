module Mjbook
  class Productcategory < ActiveRecord::Base
    has_many :products
    belongs_to :company
  end
end
