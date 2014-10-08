module Mjbook
  class Service < ActiveRecord::Base
    belongs_to :servicecategory
    belongs_to :company

    validates :servicecategory_id, presence: true
    validates :item, presence: true
    validates :quantity, presence: true, numericality: true
    validates :unit_id, presence: true
    validates :vat_id, presence: true
    validates :price, presence: true, numericality: true

  end
end
