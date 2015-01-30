module Printtables
  module PrintPaymentIndex

   # HACK the helper is included in order to allow the formatting of data for processing by prawn
    include ActionView::Helpers::NumberHelper
      
    def payment_column_widths
      [18.mm, 30.mm, 31.mm, 31.mm, 18.mm, 18.mm, 18.mm, 18.mm, 94.mm]
    end
  
    def payment_headers(price_array, total_array)
      ["Ref", "Income Type", "Income Ref", "Payment Method", "Paid Into", "Date", price_array, "VAT", total_array, "Notes"]
    end
  
    def payment_data(data, rows)
        data.each_with_index do |set, i|

          if set.invoice?
            income_ref = set.paymentitem.inline.ingroup.invoice.ref
          elsif set.transfer?
            income_ref = set.paymentitem.transfer.ref
          else
            income_ref = set.paymentitem.miscincome.ref
          end

          rows[i+1] = [
                  set.ref,
                  set.inc_type,
                  income_ref,
                  set.paymethod.text,
                  set.companyaccount.name,
                  set.date.strftime("%d/%m/%y"),
                  number_to_currency(set.price, :unit => "£"),
                  number_to_currency(set.vat_due, :unit => "£"),
                  number_to_currency(set.total, :unit => "£"),
                  set.state,
                  set.note
                       ]
        end 
    end
  
  end
end