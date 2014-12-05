module PrintQuoteFooter

  # HACK the helper is included in order to allow the formatting of data for processing by prawn
  include ActionView::Helpers::NumberHelper 
  
  def quote_total_footer(quote, pdf)
    pdf.line_width(0.1)
        
   # company_header_contents(quote, pdf)
          
    pdf.bounding_box([0.mm, 45.mm], :width => 190.mm, :height => 30.mm) do
      quote_total_header(pdf) 
      quote_subtotal_table(quote, pdf)      
    end    
  end

  def quote_total_header(pdf)
    price_array = pdf.make_table([["Price"], ["(ex VAT)"]],
                                 :column_widths => [18.mm],
                                 :cell_style => {:padding => [0.mm, 0.mm, 0.mm, 0.mm], :border_width => [0,0,0,0], :size => 7, :align => :right}
                                 ) do 
                                    row(0).size = 8 
                                    row(1).size = 6      
                                 end
    
    total_array = pdf.make_table([["Total"], ["(inc VAT)"]],
                                 :column_widths => [18.mm],
                                 :cell_style => {:padding => [0.mm, 0.mm, 0.mm, 0.mm], :border_width => [0,0,0,0], :size => 7, :align => :right}
                                 ) do 
                                    row(0).size = 8 
                                    row(1).size = 6      
                                 end

    data = [["", price_array, "", "VAT", total_array]]
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



  def quote_company_footer(quote, pdf)   
    
    pdf.line_width(0.1)
     
    footer_contents(pdf)
          
    pdf.stroke do
      pdf.line [0.mm, 10.mm],[190.mm, 10.mm]
    end

  end


  def footer_contents(pdf) 

    date = Time.now
    reformated_date = date.strftime("#{date.day.ordinalize} %b %Y")
  
  #font styles for page  
    footer_style = {:size => 7}
  #formating for lines  
    footer_format = footer_style.merge(:align => :left)

    pdf.text_box "Created: #{reformated_date}", footer_format.merge(:at =>[0.mm, pdf.bounds.bottom + 3.mm])
    
    pdf.image "#{Rails.root}/app/assets/images/myhq_logo_prawn.png", :position => :right, :vposition => 278.mm, :align => :right, :fit => [20,20]        
  end

end