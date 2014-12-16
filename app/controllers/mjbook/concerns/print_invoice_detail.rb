module PrintInvoiceDetail
  extend ActiveSupport::Concern
  include PrintDocumentStyle
  
  def invoice_details(invoice, pdf) 

    pdf.bounding_box([175.mm, 231.mm], :width => 20.mm) do    
        pdf.text invoice.project.ref, customer_style unless invoice.project.ref.blank?
        pdf.text invoice.ref, customer_style unless invoice.ref.blank?
        pdf.text invoice.customer_ref, customer_style unless invoice.customer_ref.blank?   
        pdf.text invoice.date.strftime("%d/%m/%y"), customer_style unless invoice.date.blank?
    end

  end
  
end