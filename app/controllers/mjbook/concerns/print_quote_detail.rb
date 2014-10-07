module PrintQuoteDetail

  def quote_details(quote, pdf) 
    
    data = ["Job ref:", quote.project.ref, "Quote Ref:", quote.ref, "Customer Ref:", quote.customer_ref, "Date Issued:", quote.date]

    bounding_box([0.mm, 80.mm], :width => 190.mm, :height => 10.mm) do     
      pdf.table(data, :column_widths => [20, 20, 20, ],
                      :cell_style => {:padding => [5, 5, 6, 5], :size => 8}
                      )
    end
  end
  
end