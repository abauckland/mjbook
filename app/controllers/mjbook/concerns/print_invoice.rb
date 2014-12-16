
  module PrintQuote
    extend ActiveSupport::Concern
   
    include PrintHeader
    include PrintFooter
    include PrintTable
    include PrintFooter
    include PrintPageNumbers
                 
    include PrintInvoiceHeader
    include PrintInvoiceDetail
    include PrintInvoiceTable
    include PrintInvoiceFooter
        
   def print_quote(invoice, pdf)
   
      pdf.repeat(:all) do
        ##HEADERS
        company_header(pdf)
        invoice_header(pdf)
        ##QUOTE DETAILS
        customer_details(invoice.project.customer, pdf)
        invoice_details(invoice, pdf)
        
        pdf.y = 192.mm
        table_header(pdf)
      
      end
      ##QUOTE_TABLE
      table_header(pdf)
      invoice_table(invoice, pdf)
    
      ##FOOTERS
      invoice_total_footer(invoice, pdf)
      
      invoice_terms_footer(invoice, pdf)
      
      pdf.repeat(:all) do
        company_footer(pdf)        
      end
      ##PAGE NUMBERING
      index_table_page_numbers(pdf)
               
    end

  end