module PrintQuoteDetail
  extend ActiveSupport::Concern
  include PrintDocumentStyle

  def quote_details(quote, pdf)

    pdf.bounding_box([175.mm, 231.mm], :width => 20.mm) do
        pdf.text quote.project.ref, customer_style unless quote.project.ref.blank?
        pdf.text quote.ref, customer_style unless quote.ref.blank?
        pdf.text quote.customer_ref, customer_style unless quote.customer_ref.blank?
        pdf.text quote.date.strftime("%d/%m/%y"), customer_style unless quote.date.blank?
    end

  end

end