module PrintDocumentStyle

    def customer_style
    #font styles for page
      customer_style = {:size => 8}
    #formating for lines
      customer_format = customer_style.merge(:align => :left)
    end

    def company_style
    #font styles for page
      company_style = {:size => 8}
    #formating for lines
      company_format = company_style.merge(:align => :left)
    end

    
    def price_array(pdf)
    price_array = pdf.make_table([["Price"], ["(ex VAT)"]],
                                 :column_widths => [18.mm],
                                 :cell_style => {:padding => [0.mm, 0.mm, 0.mm, 0.mm], :border_width => [0,0,0,0], :size => 7, :align => :right}
                                 ) do 
                                    row(0).size = 8 
                                    row(1).size = 6      
                                 end
    end
    
    def total_array(pdf)
    total_array = pdf.make_table([["Total"], ["(inc VAT)"]],
                                 :column_widths => [18.mm],
                                 :cell_style => {:padding => [0.mm, 0.mm, 0.mm, 0.mm], :border_width => [0,0,0,0], :size => 7, :align => :right}
                                 ) do 
                                    row(0).size = 8 
                                    row(1).size = 6      
                                 end
    end
end