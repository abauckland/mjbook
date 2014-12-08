module Printtables
  module PrintSupplierIndex
     
    def supplier_column_widths
      [35.mm, 18.mm, 40.mm, 22.mm, 22.mm, 44.mm, 35.mm, 20.mm, 40.mm]
    end
  
    def supplier_headers
      ["Name", "Position", "Address", "Tel", "Alt Tel", "Email", "Company", "VAT No.", "Notes"]
    end
  
    def supplier_data(data, rows, pdf)
        data.each_with_index do |set, i|
          
          address_table = pdf.make_table([[set.address_1],[set.address_2],[set.city],[set.county], [set.country],[set.postcode]],
                                        :column_widths => [39.mm],
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
                       set.vat_no,
                       set.notes
                       ]
        end 
    end
  
  end
end