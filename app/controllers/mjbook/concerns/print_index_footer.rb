module PrintIndexFooter

  def index_footer(filename, pdf)   
    
    pdf.line_width(0.1)
     
    footer_contents(filename, pdf)
          
    pdf.stroke do
      pdf.line [0.mm,10.mm],[277.mm,10.mm]
    end

  end


  def footer_contents(filename, pdf) 

    date = Time.now
    reformated_date = date.strftime("#{ date.day.ordinalize } %b %Y")
  
  #font styles for page  
    footer_style = {:size => 8}
  #formating for lines  
    footer_format = footer_style.merge(:align => :left)

    pdf.text_box "File: #{ filename }" , footer_format.merge(:at =>[0.mm, pdf.bounds.bottom + 8.mm])
    pdf.text_box "Created: #{ reformated_date }", footer_format.merge(:at =>[0.mm, pdf.bounds.bottom + 4.mm])
    
    pdf.image "#{Rails.root}/app/assets/images/myhq_logo.png", :position => :right, :vposition => 187.mm, :align => :right, :fit => [20,20]        
  end

end