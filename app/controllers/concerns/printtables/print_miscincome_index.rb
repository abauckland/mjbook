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
<<<<<<< HEAD
                 set.ref,
                 set.project.ref,
                 set.project.customer.company_name,
                 number_to_currency(set.price, :unit => "£"),
                 number_to_currency(set.vat, :unit => "£"),
                 number_to_currency(set.total, :unit => "£"),
                 set.date.strftime("%d/%m/%y"),
                 set.state,
                 set.notes
=======
                       set.ref,
                       set.customer.company_name,
                       set.customer_ref,
                       set.paymethod.text,
                       set.project.name,
                       set.date.strftime("%d/%m/%y"),
                       number_to_currency(set.price, :unit => "£"),
                       number_to_currency(set.vat_due, :unit => "£"),
                       number_to_currency(set.total, :unit => "£"),
                       set.state,
                       set.note
>>>>>>> d2e8a2a007bc01e123c4319a7632df214f34f5b8
                       ]

        end 
    end
  
  end
end