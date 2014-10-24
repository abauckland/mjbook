module Mjbook
  class Product < ActiveRecord::Base
    belongs_to :productcategory
    belongs_to :company
    belongs_to :unit
    belongs_to :vat

    validates :productcategory_id, presence: true
    validates :item, presence: true
    validates :vat_id, presence: true

    enum linetype: [:product, :service, :misc]

  end
end
