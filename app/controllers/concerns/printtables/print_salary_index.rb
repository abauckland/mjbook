module Printtables
  module PrintSalaryIndex

   # HACK the helper is included in order to allow the formatting of data for processing by prawn
    include ActionView::Helpers::NumberHelper
      
    def salary_column_widths
      [227.mm, 25.mm, 25.mm]
    end
  
    def salary_headers
      ["Employee", "Amount Paid", "Date"]
    end
  
    def salary_data(data, rows)
        data.each_with_index do |set, i|
          rows[i+1] = [
                       set.user.name,
                       number_to_currency(set.total, :unit => "£"),
                       set.date.strftime("%d/%m/%y")
                       ]

        end 
    end
  
  end
end
