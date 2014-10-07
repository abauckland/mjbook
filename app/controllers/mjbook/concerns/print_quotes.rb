#index table

    include Print_quote_header
    include Print_quote_detail    
    include Print_quote_table
    include Print_quote_total
    include Print_quote_footer
    
   document = Prawn::Document.new(
    :page_size => "A4",
    :margin => [5.mm, 10.mm, 5.mm, 10.mm],
    :info => {:title => @project.title}
    ) do |pdf|    

      ##HEADERS
      quote_company_header(quote, pdf) 

      quote_customer_header(quote, pdf) 

      ##QUOTE DETAILS
      quote_details(quote, pdf) 

      ##QUOTE_TABLE
      quote_table(quote, pdf) 
    
      ##FOOTERS
      quote_total_footer(quote, pdf)
      
      quote_terms_footer(quote, pdf) 
      
      quote_company_footer(quote, pdf) 

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