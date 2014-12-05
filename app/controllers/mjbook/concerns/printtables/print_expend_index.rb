module Printtables
  module PrintExpendIndex
   # HACK the helper is included in order to allow the formatting of data for processing by prawn
    include ActionView::Helpers::NumberHelper
     
    def expend_column_widths
      [17.mm, 30.mm, 30.mm, 30.mm, 30.mm, 20.mm, 18.mm, 18.mm, 18.mm, 18.mm, 150.mm]
    end
  
    def expend_headers(price_array, total_array)
      ["Ref", "Employee", "Supplier", "Payment Method", "Company Account", "Receipt", "Date",
        price_array, "VAT", total_array, "Note"]
    end
  
    def expend_data(data, rows)
        data.each_with_index do |set, i|
          rows[i+1] = [
                       set.ref,
                       set.user.name,
                       set.expense.supplier.company_name,
                       set.paymethod.method,
                       set.companyaccount.name,
                       set..expend_receipt,
                       set.date.strftime("%d/%m/%y"),
                       number_to_currency(set.price, :unit => "£"),
                       number_to_currency(set.vat, :unit => "£"),
                       number_to_currency(set.total, :unit => "£"),
                       set.note
                       ]
        end 
    end
  
  end
end