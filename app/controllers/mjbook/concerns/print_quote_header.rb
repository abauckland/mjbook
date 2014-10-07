module PrintIndexHeader

  def quote_company_header(company, filter, index, pdf)  
    
    pdf.line_width(0.1)
        
    company_header_contents(company, index, pdf)
          
    pdf.bounding_box([0.mm, 0.mm], :width => 190.mm, :height => 40.mm) do
      pdf.stroke_bounds
    end
  end


  def company_header_contents(company, filters, index, pdf)
  #font styles for page  
    company_style = {:size => 8}  
  #formating for lines  
    company_format = company_style.merge(:align => :left)
    
  #header layout
    pdf.bounding_box([0,17.mm], :width => 100.mm, :height => 40.mm) do
      
        pdf.text company.name, company_style unless company.reg_name.blank?
        pdf.text company.address_1, company_style unless company.address_1.blank?
        pdf.text company.address_2, company_style unless company.address_2.blank?
        pdf.text company.city, company_style unless company.city.blank?
        pdf.text company.county, company_style unless company.county.blank?
        pdf.text company.country, company_style unless company.country.blank?
        pdf.text company.postcode, company_style unless company.postcode.blank?
        pdf.move_down(3.mm)
        pdf.text company.tel, company_style unless company.tel.blank?
        pdf.text company.alt_tel, company_style unless company.alt_tel.blank?
        pdf.text company.email, company_style unless company.email.blank?
        pdf.text "#{company.subdomain}.myhq.org.uk", company_style unless company.subdomain.blank?

    end

    pdf.bounding_box([0,17.mm], :width => 100.mm, :height => 40.mm) do
      
        pdf.text "Reg No: #{company.reg_no}", company_style unless company.reg_no.blank?
        pdf.text "VAT No: #{company.vat_no}", company_style unless company.vat_no.blank?

    end

    unless company.logo.blank?
      pdf.image company.logo.path, :position => :right, :vposition => -12.mm, :fit => [250,35]
    end
     
  end
end

  

