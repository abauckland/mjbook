module Printtables
  module PrintMiscincomeIndex

   # HACK the helper is included in order to allow the formatting of data for processing by prawn
    include ActionView::Helpers::NumberHelper
      
    def miscincome_column_widths
      [18.mm, 30.mm, 18.mm, 30.mm, 30.mm, 18.mm, 18.mm, 18.mm, 18.mm, 18.mm, 61.mm]
    end
  
    def miscincome_headers(price_array, total_array)
      ["Ref", "Invoice Ref", "Paid Into", "Date", price_array, "VAT", total_array, "Status", "Notes"]
    end
  
    def miscincome_data(data, rows)
        data.each_with_index do |set, i|
          rows[i+1] = [
                       set.ref,
                       set.customer.company_name,
                       set.customer_ref,
                       set.paymethod.text,
                       set.project.name,
                       set.date.strftime("%d/%m/%y"),
                       number_to_currency(set.price, :unit => "£"),
                       number_to_currency(set.vat_due, :unit => "£"),
                       number_to_currency(set.total, :unit => "£"),
                       set.status,
                       set.note
                       ]

        end 
    end
  
  end
end