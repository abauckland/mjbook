module PrintQuoteDetail

  def quote_details(quote, pdf) 

  #font styles for page  
    customer_style = {:size => 8}  
  #formating for lines  
    customer_format = customer_style.merge(:align => :left)


    pdf.bounding_box([0.mm, 231.mm], :width => 15.mm, :height => 5.mm) do
        pdf.text "Deliver to:", {:size => 7, :align => :left, :font_style => :italic}
    end

    pdf.bounding_box([0.mm, 227.mm], :width => 15.mm, :height => 20.mm) do
        pdf.text "Address:", customer_style
    end

    pdf.bounding_box([0.mm, 202.mm], :width => 15.mm, :height => 10.mm) do
        pdf.text "Contact:", customer_style
        pdf.text "Tel:", customer_style
        pdf.text "E-mail:", customer_style
    end

    pdf.bounding_box([15.mm, 227.mm], :width =>60.mm, :height => 20.mm) do
        pdf.text quote.project.customer.address_1, customer_style unless quote.project.customer.address_1.blank?
        pdf.text quote.project.customer.address_2, customer_style unless quote.project.customer.address_2.blank?
        pdf.text quote.project.customer.city, customer_style unless quote.project.customer.city.blank?
        pdf.text quote.project.customer.county, customer_style unless quote.project.customer.county.blank?
        pdf.text quote.project.customer.country, customer_style unless quote.project.customer.country.blank?
        pdf.text quote.project.customer.postcode, customer_style unless quote.project.customer.postcode.blank?
    end

    pdf.bounding_box([15.mm, 202.mm], :width => 60.mm, :height => 10.mm) do
        pdf.text quote.project.customer.name, customer_style unless quote.project.customer.name.blank?
        pdf.text quote.project.customer.phone, customer_style unless quote.project.customer.phone.blank?
        pdf.text quote.project.customer.email, customer_style unless quote.project.customer.email.blank?
    end


    pdf.bounding_box([155.mm, 231.mm], :width => 20.mm) do   
        pdf.text "Job Ref:", customer_style
        pdf.text "Quote Ref:", customer_style
        pdf.text "Customer Ref:", customer_style
        pdf.text "Date Issued:", customer_style
    end

    pdf.bounding_box([175.mm, 231.mm], :width => 20.mm) do    
        pdf.text quote.project.ref, customer_style unless quote.project.ref.blank?
        pdf.text quote.ref, customer_style unless quote.ref.blank?
        pdf.text quote.customer_ref, customer_style unless quote.customer_ref.blank?   
        pdf.text quote.date.strftime("%d/%m/%y"), customer_style unless quote.date.blank?
    end

    pdf.bounding_box([155.mm, 202.mm], :width => 10.mm) do   
        pdf.text "Page:", customer_style
    end


    pdf.line_width(0.1)

    pdf.stroke do
      pdf.line [0.mm, 190.mm],[190.mm, 190.mm]
    end

  end
  
end