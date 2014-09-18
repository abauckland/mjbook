module Mjbook
  class Product < ActiveRecord::Base
    belongs_to :productcategory
    belongs_to :company
  end
end
