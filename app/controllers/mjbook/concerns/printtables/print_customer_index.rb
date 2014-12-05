module Printtables
  module PrintCustomerIndex
     
    def customer_column_widths
      [40.mm, 25.mm, 40.mm, 25.mm, 25.mm, 40.mm, 40.mm, 42.mm]
    end
  
    def customer_headers
      ["Name", "Position", "Address", "Tel", "Alt Tel", "Email", "Company", "Notes"]
    end
  
    def customer_data(data, rows, pdf)
        data.each_with_index do |set, i|
          
          address_table = pdf.make_table([[set.address_1],[set.address_2],[set.city],[set.county], [set.country],[set.postcode]],
                                        :column_widths => [38.mm],
                                        :cell_style => {:padding => [0.mm, 0.mm, 0.mm, 0.mm], :border_width => [0,0,0,0], :size => 8}
                                        )
          
          rows[i+1] = [
                       set.name,
                       set.position,
                       address_table,
                       set.phone,
                       set.alt_phone,
                       set.email,
                       set.company_name,
                       set.notes
                       ]
        end 
    end
  
  end
end