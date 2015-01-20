module PrintFooter

  # HACK the helper is included in order to allow the formatting of data for processing by prawn
  include ActionView::Helpers::NumberHelper 
  
  def company_footer(pdf)   
    
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
    
  #  pdf.image "#{Rails.root}/app/assets/images/myhq_logo_prawn.png", :position => :right, :vposition => 278.mm, :align => :right, :fit => [20,20]        
  end

end