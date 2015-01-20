module Printtables
  module PrintQuoteIndex
   
   # HACK the helper is included in order to allow the formatting of data for processing by prawn
    include ActionView::Helpers::NumberHelper  
  
    def quote_column_widths
      [17.mm, 18.mm, 45.mm, 17.mm, 45.mm, 45.mm, 18.mm, 18.mm, 18.mm, 18.mm, 18.mm]
    end
  
    def quote_headers(price_array, total_array)
      ["Job Ref", "Quote Ref", "Quote Title", "Cust. Ref", "Customer Name", "Customer Company", "Date",
        price_array, "VAT", total_array, "Status"]
    end
  
    def quote_data(data, rows)
        data.each_with_index do |set, i|
          rows[i+1] = [
                       set.project.ref,
                       set.ref,
                       set.title,
                       set.customer_ref,
                       set.project.customer.name,
                       set.project.customer.company_name,
                       set.date.strftime("%d/%m/%y"),
                       number_to_currency(set.price, :unit => "£"),
                       number_to_currency(set.vat_due, :unit => "£"),
                       number_to_currency(set.total, :unit => "£"),
                       set.status
                       ]
        end 
    end
  
  end
end