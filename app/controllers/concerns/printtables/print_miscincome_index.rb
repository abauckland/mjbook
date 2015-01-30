module Printtables
  module PrintMiscincomeIndex

   # HACK the helper is included in order to allow the formatting of data for processing by prawn
    include ActionView::Helpers::NumberHelper
      
    def miscincome_column_widths
      [18.mm, 18.mm, 30.mm, 18.mm, 18.mm, 18.mm, 18.mm, 18.mm, 121.mm]
    end
  
    def miscincome_headers(price_array, total_array)
      ["Reference","Job Reference", "Customer", price_array, "VAT", total_array, "Date", "Status", "Notes"]
    end
  
    def miscincome_data(data, rows)
        data.each_with_index do |set, i|
          rows[i+1] = [
                 set.ref,
                 set.project.ref,
                 set.project.customer.company_name,
                 number_to_currency(set.price, :unit => "£"),
                 number_to_currency(set.vat, :unit => "£"),
                 number_to_currency(set.total, :unit => "£"),
                 set.date.strftime("%d/%m/%y"),
                 set.state,
                 set.notes
                ]

        end 
    end
  
  end
end