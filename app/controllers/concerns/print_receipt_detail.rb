module PrintReceiptDetail
  extend ActiveSupport::Concern
  include PrintDocumentStyle
  
  def receipt_details(payment, pdf) 

    invoice_ref = payment.paymentitem.inline.ingroup.invoice.ref
    invoice_customer_ref = payment.paymentitem.inline.ingroup.invoice.customer_ref

    pdf.bounding_box([175.mm, 231.mm], :width => 20.mm) do
        pdf.text payment.ref, customer_style unless payment.ref.blank?
        pdf.text invoice_ref, customer_style unless invoice_ref.blank?
        pdf.text invoice_customer_ref, customer_style unless invoice_customer_ref.blank?  
        pdf.text payment.date.strftime("%d/%m/%y"), customer_style unless payment.date.blank?
    end

  end
  
end