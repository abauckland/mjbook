  module PrintReceipt
    extend ActiveSupport::Concern
   
    include PrintHeader
    include PrintCustomerDetail
    include PrintFooter
    include PrintTable
    include PrintFooter
    include PrintPageNumbers
                 
    include PrintReceiptHeader
    include PrintReceiptDetail
    include PrintReceiptTable
    include PrintReceiptFooter
        
   def print_receipt(payment, pdf)
   
      pdf.repeat(:all) do
        ##HEADERS
        company_header(pdf)
        receipt_header(pdf)
        ##QUOTE DETAILS
        customer = Mjbook::Customer.joins(:projects => [:invoices => [:inlines => :paymentitems]]
                                  ).where('mjbook_paymentitems.payment_id' => payment.id
                                  ).first
        customer_details(customer, pdf)
        receipt_details(payment, pdf)
        
        pdf.y = 192.mm
        table_header(pdf)
      
      end
      ##QUOTE_TABLE
      receipt_table(payment, pdf)
    
      ##FOOTERS
      receipt_total_footer(payment, pdf)
            
      pdf.repeat(:all) do
        company_footer(pdf)        
      end
      ##PAGE NUMBERING
      index_table_page_numbers(pdf)
               
    end

  end