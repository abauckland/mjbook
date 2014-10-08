module Mjbook
  class Rate < ActiveRecord::Base
    belongs_to :ratecategory
    belongs_to :company

    validates :ratecategory_id, presence: true
    validates :item, presence: true
    validates :quantity, presence: true, numericality: true
    validates :unit_id, presence: true
    validates :vat_id, presence: true
    validates :price, presence: true, numericality: true

  end
end
