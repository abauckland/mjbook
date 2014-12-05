
  module PrintQuote
    extend ActiveSupport::Concern

    include PrintQuoteHeader
    include PrintQuoteDetail    
    include PrintQuoteTable
#    include Print_quote_total
    include PrintQuoteFooter
    
   def print_quote(quote, pdf)
   
      pdf.repeat(:all) do
        ##HEADERS
        quote_company_header(quote, pdf) 
        ##QUOTE DETAILS
        quote_details(quote, pdf) 
        
        pdf.y = 192.mm
        table_header(pdf)      
      
      end
      ##QUOTE_TABLE
      quote_table(quote, pdf) 
    
      ##FOOTERS
      quote_total_footer(quote, pdf)
      
      quote_terms_footer(quote, pdf) 
      
      pdf.repeat(:all) do      
        quote_company_footer(quote, pdf) 
      end
      ##PAGE NUMBERING
      index_table_page_numbers(pdf)
               
    end    

    
    def index_table_page_numbers(pdf)
      page_string = "<page> of <total>"      
      options = {:at => [175.mm, 202.mm],
        :width => 15.mm,
        :align => :left,
        :start_count_at => 1,
        :size => 8
        }
      
      pdf.number_pages page_string, options
    end

  end