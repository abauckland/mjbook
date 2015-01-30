module Printtables
  module PrintCreditnoteIndex

   # HACK the helper is included in order to allow the formatting of data for processing by prawn
    include ActionView::Helpers::NumberHelper

    def creditnote_column_widths
      [18.mm, 18.mm, 18.mm, 18.mm, 18.mm, 186.mm]
    end

    def creditnote_headers
      ["Reference", price_array, "VAT", total_array, "Date", "Notes"]
    end

    def creditnote_data(data, rows)
        data.each_with_index do |set, i|
          rows[i+1] = [
                       set.ref,
                       #set.writeoffitem.inline.ingroup.invoice.ref
                       #set.writeoffitem.inline.ingroup.invoice.project.customer.company_name
                       number_to_currency(set.price, :unit => "£"),
                       number_to_currency(set.vat, :unit => "£"),
                       number_to_currency(set.total, :unit => "£"),
                       set.date.strftime("%d/%m/%y"),
                       set.notes
                       ]
        end 
    end

  end
end