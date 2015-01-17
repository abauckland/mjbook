
  module PrintQuote
    extend ActiveSupport::Concern
   
    include PrintHeader
    include PrintFooter
    include PrintTable
    include PrintFooter
    include PrintPageNumbers
                 
    include PrintQuoteHeader
    include PrintQuoteDetail
    include PrintQuoteTable
    include PrintQuoteFooter
        
   def print_quote(quote, pdf)
   
      pdf.repeat(:all) do
        ##HEADERS
        company_header(pdf)
        quote_header(pdf)
        ##QUOTE DETAILS
        customer_details(quote.project.customer, pdf)
        quote_details(quote, pdf)
        
        pdf.y = 192.mm
        table_header(pdf)
      
      end
      ##QUOTE_TABLE
      print_table(quote, pdf)
      quote_table(quote, pdf)
    
      ##FOOTERS
      quote_total_footer(quote, pdf)
      
      quote_terms_footer(quote, pdf)
      
      pdf.repeat(:all) do
        company_footer(pdf)        
      end
      ##PAGE NUMBERING
      index_table_page_numbers(pdf)
               
    end

  end