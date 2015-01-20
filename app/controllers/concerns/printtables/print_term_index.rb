module Printtables
  module PrintTermIndex
     
    def term_column_widths
      [50.mm, 25.mm, 202.mm]
    end
  
    def term_headers
      ["Reference","Period (days)","Terms"]
    end
  
    def term_data(data, rows)
        data.each_with_index do |set, i|
          rows[i+1] = [
                       set.ref,
                       set.period,
                       set.terms
                       ]
        end 
    end
  
  end
end