  module PrintCredit
    extend ActiveSupport::Concern
   
    include PrintHeader
    include PrintCustomerDetail
    include PrintFooter
    include PrintTable
    include PrintFooter
    include PrintPageNumbers
                 
    include PrintCreditHeader
    include PrintCreditDetail
    include PrintCreditTable
    include PrintCreditFooter
        
   def print_credit(credit, pdf)
   
      pdf.repeat(:all) do
        ##HEADERS
        company_header(pdf)
        credit_header(pdf)
        ##QUOTE DETAILS
        customer_details(credit.project.customer, pdf)
        credit_details(credit, pdf)
        
        pdf.y = 192.mm
        table_header(pdf)
      
      end
      ##QUOTE_TABLE
      credit_table(credit, pdf)
    
      ##FOOTERS
      credit_total_footer(credit, pdf)
      
      pdf.repeat(:all) do
        company_footer(pdf)        
      end
      ##PAGE NUMBERING
      index_table_page_numbers(pdf)
               
    end

  end