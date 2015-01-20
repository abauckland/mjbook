module Printtables
  module PrintBusinessIndex
   # HACK the helper is included in order to allow the formatting of data for processing by prawn
    include ActionView::Helpers::NumberHelper
         
    def business_column_widths
      [17.mm, 18.mm, 17.mm, 39.mm, 39.mm, 39.mm, 18.mm, 18.mm, 18.mm, 18.mm, 18.mm, 18.mm]
    end
  
    def business_headers(price_array, total_array)
      ["Ref", "Due Date", "Job", "Expenditure Category", "Supplier", "Supplier Ref:", "Issued Date", "Reciept",
        price_array, "VAT", total_array, "Status"]
    end
  
    def business_data(data, rows)
        data.each_with_index do |set, i|
          rows[i+1] = [
                       set.ref,
                       set.due_date.strftime("%d/%m/%y"),
                       set.project.ref,
                       set.hmrcexpcat.category,
                       set.supplier.company_name,
                       set.supplier_ref,
                       set.date.strftime("%d/%m/%y"),
                       set.receipt,
                       number_to_currency(set.price, :unit => "£"),
                       number_to_currency(set.vat, :unit => "£"),
                       number_to_currency(set.total, :unit => "£"),
                       set.status
                       ]
        end 
    end
  
  end
end
