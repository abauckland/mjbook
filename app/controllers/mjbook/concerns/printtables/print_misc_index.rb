module Printtables
  module PrintMiscIndex

   # HACK the helper is included in order to allow the formatting of data for processing by prawn
    include ActionView::Helpers::NumberHelper
      
    def misc_column_widths
      [50.mm, 227.mm]
    end
  
    def misc_headers
      ["Category", "Item"]
    end
  
    def misc_data(data, rows)
        data.each_with_index do |set, i|
          rows[i+1] = [
                       set.productcategory.text,
                       set.item,
                       ]
        end 
    end
  
  end
end