module PrintCreditDetail
  extend ActiveSupport::Concern
  include PrintDocumentStyle
  
  def credit_details(credit, pdf)
    invoice_ref = credit.credititem.inline.ingroup.invoice.ref
    invoice_customer_ref = credit.credititem.inline.ingroup.invoice.customer_ref

    pdf.bounding_box([175.mm, 231.mm], :width => 20.mm) do
        pdf.text credit.ref, customer_style unless credit.ref.blank?
        pdf.text invoice_ref, customer_style unless invoice_ref.blank?
        pdf.text invoice_customer_ref, customer_style unless invoice_customer_ref.blank?
        pdf.text credit.date.strftime("%d/%m/%y"), customer_style unless credit.date.blank?
    end

  end
  
end