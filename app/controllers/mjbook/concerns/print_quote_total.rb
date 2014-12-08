module PrintQuoteTotal

  def quote_total_footer(quote, pdf) 
    
    data = [
              ["", "VAT total", quote.total_vat],
              ["", "Total", quote.total_price]
           ]

    bounding_box([0.mm, 247.mm], :width => 190.mm, :height => 10.mm) do     
      pdf.table(data, :column_widths => [150.mm, 20.mm, 20.mm],
                      :cell_style => {:padding => [5, 5, 6, 5], :size => 8}
                      )
    end
    
  end
  
  
  def quote_terms_footer(quote, pdf) 
   
    bounding_box([0.mm, 80.mm], :width => 190.mm, :height => 20.mm) do     
      pdf.text quote.term.text
    end
    
  end

  
end