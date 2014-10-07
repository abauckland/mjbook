module PrintIndexHeader

  def header(company, filter, index, pdf)  
    
    pdf.line_width(0.1)
        
    header_contents(company, index, pdf)
          
    pdf.stroke do
      pdf.line [0.mm, 180.mm],[277.mm, 180.mm]
    end
  end


  def header_contents(company, filters, index, pdf)
  #font styles for page  
    header_style = {:size => 8}  
  #formating for lines  
    header_format = header_style.merge(:align => :left)
    
  #header layout
    pdf.spec_box "#{index.capitalize}", header_format.merge(:at =>[0.mm, 190.mm])
    
    unless filter.blank?      
      if filter.type == "project"
        pdf.spec_box "Job:#{filter.project_ref}. From:#{filter.start_date} To:#{filter.end_date}", header_format.merge(:at =>[0.mm, 190.mm])
      end
    end
     
    pdf.image company.logo.path, :position => :right, :vposition => -12.mm, :align => :right, :fit => [250,25]        
  end

end
