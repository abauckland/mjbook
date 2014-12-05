#index table

    include Printheader
    include Printfooter

   document = Prawn::Document.new(
    :page_size => "A4",
    :page_layout => "landscape",
    :margin => [20.mm, 14.mm, 5.mm, 20.mm],
    :info => {:title => @project.title}
    ) do |pdf|    

      ##INDEX_TABLE
      index_table(pdf) 

      ##HEADERS
      table_header(company, pdf) 
    
      ##FOOTERS
      table_footer(pdf)  

      ##PAGE NUMBERING
      table_page_numbers(pdf)
         
    end 
    
#invoice/quote/receipt    
   document = Prawn::Document.new(
    :page_size => "A4",
    :margin => [20.mm, 14.mm, 5.mm, 20.mm],
    :info => {:title => @project.title}
    ) do |pdf|    

      ##INDEX_TABLE
      index_table(pdf) 

      ##HEADERS
      header(pdf) 
    
      ##FOOTERS
      footer(pdf)  

      ##PAGE NUMBERING
      page_numbers(pdf)
                  
    end      