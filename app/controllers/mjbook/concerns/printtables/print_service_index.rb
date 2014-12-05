module Printtables
  module PrintServiceIndex

   # HACK the helper is included in order to allow the formatting of data for processing by prawn
    include ActionView::Helpers::NumberHelper
      
    def service_column_widths
      [50.mm, 137.mm, 20.mm, 20.mm, 20.mm, 20.mm, 30.mm, 20.mm, 20.mm]
    end
  
    def service_headers(price_array, total_array)
      ["Category", "Item", price_array, "VAT Rate", "VAT", total_array]
    end
  
    def service_data(data, rows)
        data.each_with_index do |set, i|
          rows[i+1] = [
                       set.productcategory.text,
                       set.item,
                       number_to_currency(set.price, :unit => "£"),
                       set.vat.cat,                       
                       number_to_currency(set.vat_due, :unit => "£"),
                       number_to_currency(set.total, :unit => "£"),
                       ]
        end 
    end
  
  end
end