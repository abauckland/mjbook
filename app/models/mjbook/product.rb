module Mjbook
  class Product < ActiveRecord::Base
    belongs_to :productcategory
    belongs_to :company

    validates :productcategory_id, presence: true
    validates :item, presence: true
    validates :quantity, presence: true, numericality: true
    validates :unit_id, presence: true
    validates :cost, presence: true, numericality: true
    validates :vat_id, presence: true
    validates :price, presence: true, numericality: true

  end
end
