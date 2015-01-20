module PrintCreditHeader
  extend ActiveSupport::Concern
  include PrintDocumentStyle

  def credit_header(pdf)  
    
    pdf.bounding_box([0.mm, 280.mm], :width => 190.mm, :height => 15.mm) do
      pdf.text "Credit Note", {:size => 24, :align => :right, :font_style => :bold}      
    end
    
  end
  
end

  

