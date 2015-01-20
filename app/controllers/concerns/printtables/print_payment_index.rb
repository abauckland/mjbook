module Printtables
  module PrintPaymentIndex

   # HACK the helper is included in order to allow the formatting of data for processing by prawn
    include ActionView::Helpers::NumberHelper
      
    def payment_column_widths
      [18.mm, 18.mm, 40.mm, 18.mm, 18.mm, 18.mm, 18.mm, 129.mm]
    end
  
    def payment_headers(price_array, total_array)
      ["Ref", "Invoice Ref", "Paid Into", "Date", price_array, "VAT", total_array, "Notes"]
    end
  
    def payment_data(data, rows)
        data.each_with_index do |set, i|
          rows[i+1] = [
                       set.ref,
                       set.invoice.ref,
                       set.paymethod.text,
                       set.companyaccount.name,
                       set.date.strftime("%d/%m/%y"),
                       number_to_currency(set.price, :unit => "£"),
                       number_to_currency(set.vat_due, :unit => "£"),
                       number_to_currency(set.total, :unit => "£"),
                       set.note
                       ]
        end 
    end
  
  end
end