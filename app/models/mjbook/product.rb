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

    def self.to_csv

      require 'csv'

      CSV.generate do |csv|
        csv << ["Category", "Item", "Quantity", "Unit", "Rate", "Price", "VAT Rate", "VAT", "Total"]
        all.each do |set|
          csv << [
                 set.productcategory.text,
                 set.item,
                 set.quantity,
                 set.unit.text,
                 set.rate,
                 set.price,
                 set.vat.cat,
                 set.vat_due,
                 set.total,
                 ]

        end
      end
    end

    private

      default_scope { order('item ASC') }


  end
end
