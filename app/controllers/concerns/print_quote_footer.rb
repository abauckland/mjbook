module PrintQuoteFooter

  # HACK the helper is included in order to allow the formatting of data for processing by prawn
  include ActionView::Helpers::NumberHelper 
  extend ActiveSupport::Concern
  include PrintDocumentStyle
    
  def quote_total_footer(quote, pdf)
    pdf.line_width(0.1)
        
   # company_header_contents(quote, pdf)
          
    pdf.bounding_box([0.mm, 45.mm], :width => 190.mm, :height => 30.mm) do
      quote_total_header(pdf) 
      quote_subtotal_table(quote, pdf)      
    end    
  end

  def quote_total_header(pdf)

    data = [["", price_array(pdf), "", "VAT", total_array(pdf)]]
    column_widths = [122.mm, 18.mm, 14.mm, 18.mm, 18.mm]
      
    pdf.table(data, 
              :column_widths => column_widths,
              :cell_style => {:padding => [2.mm, 0.mm, 2.mm, 0.mm], :border_width => [1,0,0,0], :size => 7, :font_style => :italic}
              ) do
                values = cells.columns(1..5)                  
                values.align = :right                  
              end        
  end

  def quote_total_data(quote) 
    [["", "Total", number_to_currency(quote.price, :unit => "£"), "", number_to_currency(quote.vat_due, :unit => "£"), number_to_currency(quote.total, :unit => "£")]]
  end  
  
  def quote_total_options    
    {
    :column_widths => [8.mm, 114.mm, 18.mm, 14.mm, 18.mm, 18.mm],
    :cell_style => {:padding => [2.mm, 0.mm, 5.mm, 0.mm], :border_width => [0,0,0,0], :size => 8, :font_style => :bold}
    }
  end

  def quote_subtotal_table(quote, pdf)      
    pdf.table(quote_total_data(quote), quote_total_options) do
              values = cells.columns(1..5)                  
              values.align = :right                  
    end         
  end



  def quote_terms_footer(quote, pdf)

    pdf.bounding_box([0.mm, 23.mm], :width => 190.mm, :height => 10.mm) do
      #pdf.stroke_bounds
      pdf.text "Terms: "+quote.quoteterm.terms, :size => 8, :align => :justify, :valign => :bottom
    end
    
  end

end