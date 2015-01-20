module Printtables
  module PrintWriteoffIndex

   # HACK the helper is included in order to allow the formatting of data for processing by prawn
    include ActionView::Helpers::NumberHelper

    def writeoff_column_widths
      [18.mm, 18.mm, 18.mm, 18.mm, 18.mm, 18.mm, 169.mm]
    end

    def writeoff_headers
      ["Reference","Price", "VAT", "Total", "Date", "Status", "Notes"]
    end

    def writeoff_data(data, rows)
        data.each_with_index do |set, i|
          rows[i+1] = [
                       set.ref,
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