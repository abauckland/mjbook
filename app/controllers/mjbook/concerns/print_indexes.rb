#index table

    include Print_index_header
    include Print_index_table
    include Print_index_footer
    
   document = Prawn::Document.new(
    :page_size => "A4",
    :page_layout => "landscape",
    :margin => [5.mm, 10.mm, 5.mm, 10.mm],
    :info => {:title => @company.name}
    ) do |pdf|    

      ##HEADERS
      table_header(company, filter, index, pdf) 

      ##INDEX_TABLE
      index_table(data, index, pdf) 
    
      ##FOOTERS
      table_footer(company, index, pdf)  

      ##PAGE NUMBERING
      index_table_page_numbers(pdf)         
    end    

    
    def index_table_page_numbers(pdf)
      string = "page <page> of <total>"      
      options = {:at => [277.mm, 6.mm],
        :width => 20.mm,
        :align => :right,
        :start_count_at => 1
        }
      
      number_pages string options
    end   