module PrintQuoteHeader

  def quote_company_header(quote, pdf)  
  #font styles for page  
    company_style = {:size => 8}  
  #formating for lines  
    company_format = company_style.merge(:align => :left)

  
#    pdf.image quote.company.logo, :position => :right, :vposition => 5.mm, :fit => [75,15]
    
    pdf.bounding_box([0.mm, 280.mm], :width => 190.mm, :height => 15.mm) do
      pdf.text "Quotation", {:size => 24, :align => :right, :font_style => :bold}      
    end
              
    pdf.bounding_box([0.mm, 265.mm], :width => 95.mm, :height => 20.mm) do
        pdf.text quote.project.company.name, company_style unless quote.project.company.name.blank?
        pdf.text quote.project.company.address_1, company_style unless quote.project.company.address_1.blank?
        pdf.text quote.project.company.address_2, company_style unless quote.project.company.address_2.blank?
        pdf.text quote.project.company.city, company_style unless quote.project.company.city.blank?
        pdf.text quote.project.company.county, company_style unless quote.project.company.county.blank?
        pdf.text quote.project.company.postcode, company_style unless quote.project.company.postcode.blank?
    end

    pdf.bounding_box([0.mm, 243.mm], :width => 95.mm, :height => 12.mm) do
        pdf.text quote.project.company.email, company_style unless quote.project.company.email.blank?
        pdf.text "#{quote.project.company.subdomain}.myhq.org.uk", company_style unless quote.project.company.subdomain.blank?
    end

    pdf.bounding_box([155.mm, 265.mm], :width => 50.mm, :height => 20.mm) do
        pdf.text "Tel: "+quote.project.company.tel, company_style unless quote.project.company.tel.blank?
        pdf.text "Mob: "+quote.project.company.alt_tel, company_style unless quote.project.company.alt_tel.blank?
    end

    pdf.bounding_box([155.mm, 243.mm], :width => 50.mm, :height => 12.mm) do
        pdf.text "Reg No: #{quote.project.company.reg_no}", company_style unless quote.project.company.reg_no.blank?
        pdf.text "VAT No: #{quote.project.company.vat_no}", company_style unless quote.project.company.vat_no.blank?
    end

    pdf.line_width(0.1)

    pdf.stroke do
      pdf.line [0.mm, 234.mm],[190.mm, 234.mm]
    end
    
  end
  
end

  

