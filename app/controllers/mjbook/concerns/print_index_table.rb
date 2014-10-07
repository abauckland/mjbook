module PrintIndexTable

  def index_table(data, index, pdf)   
         
    bounding_box [0.mm, 20.mm], :width => 277.mm, :height => 170.mm do  
      table_contents(data, index, pdf)          
    end
     
  end


  def table_contents(data, index, pdf) 

  #font styles for page  
    table_style = {:size => 8}
  #formating for lines  
    table_format = table_style.merge(:align => :left)
    
    pdf.table(data, :header => true,
                    :row_colors => ["#ffffff", "bbbbbb"], 
                    :column_widths => [column_widths(index)],
                    :cell_style => {:padding => [5, 5, 6, 5], :border_width => [0,0,0,0], :size => 8}
                    ) do
                      table.header.font_style = :bold
                      table.header.size = 10  
                      table.header.border_width = [0,0,1,0]                                          
                    end         
  end

  def column_widths(index)
    case index
      #table columns: 
      when 'supplier' ; []
      when 'customer' ; []    
      when 'job' ; []
      when 'quotes' ; []
      when 'invoices' ; []
      when 'payments' ; []                  
      when 'business' ; []
      when 'personal' ; []
      when 'expenses' ; []
      when 'expenditure' ; []   
      when 'employee' ; []
      #table columns: cat, item, quantity, unit, rate, vat_rat, vat, price 
      when 'products' ; [40.mm, 177.mm, 10.mm, 10.mm, 10.mm, 10.mm, 10.mm, 10.mm] 
      #table columns: cat, item, notes, quantity, unit, rate, vat_rat, vat, price 
      when 'services' ; [40.mm, 60.mm, 117.mm, 10.mm, 10.mm, 10.mm, 10.mm, 10.mm, 10.mm]
      when 'rates'    ; [40.mm, 60.mm, 117.mm, 10.mm, 10.mm, 10.mm, 10.mm, 10.mm, 10.mm]   
      #table columns: cat, item, notes 
      when 'misc'     ; [40.mm, 60.mm, 177.mm]
      when 'mileages' ; []
      when 'vat_rates' ; []                
      when 'hmrcexpcat' ; []
      when 'quote_terms' ; []
      when 'invoice_terms' ; []
    end    
  end

end