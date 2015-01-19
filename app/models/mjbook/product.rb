module Mjbook
  class Product < ActiveRecord::Base
    belongs_to :productcategory
    belongs_to :company
    belongs_to :unit
    belongs_to :vat

    validates :productcategory_id, presence: true
    validates :item, presence: true, uniqueness: {:scope => [:company_id]}
    validates :quantity, :unit_id, :rate, :price, :vat_id, :vat_due, :total, numericality: true

    enum linetype: [:product, :service, :misc]


    private

      default_scope { order('item ASC') }


  end
end
