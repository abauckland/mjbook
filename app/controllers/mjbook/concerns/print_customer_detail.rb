module PrintCustomerDetail
  extend ActiveSupport::Concern
  include PrintDocumentStyle
  
  def customer_details(customer, pdf)

    pdf.bounding_box([0.mm, 231.mm], :width => 15.mm, :height => 5.mm) do
        pdf.text "Deliver to:", {:size => 7, :align => :left, :font_style => :italic}
    end

    pdf.bounding_box([0.mm, 227.mm], :width => 15.mm, :height => 20.mm) do
        pdf.text "Company:", customer_style        
        pdf.text "Address:", customer_style
    end

    pdf.bounding_box([0.mm, 202.mm], :width => 15.mm, :height => 10.mm) do
        pdf.text "Contact:", customer_style
        pdf.text "Tel:", customer_style
        pdf.text "E-mail:", customer_style
    end

    pdf.bounding_box([15.mm, 227.mm], :width =>60.mm, :height => 20.mm) do
        pdf.text customer.company_name, customer_style unless customer.company_name.blank?
        pdf.text customer.address_1, customer_style unless customer.address_1.blank?
        pdf.text customer.address_2, customer_style unless customer.address_2.blank?
        pdf.text customer.city, customer_style unless customer.city.blank?
        pdf.text customer.county, customer_style unless customer.county.blank?
        pdf.text customer.country, customer_style unless customer.country.blank?
        pdf.text customer.postcode, customer_style unless customer.postcode.blank?
    end

    pdf.bounding_box([15.mm, 202.mm], :width => 60.mm, :height => 10.mm) do

        pdf.text customer.name, customer_style unless customer.name.blank?
        pdf.text customer.phone, customer_style unless customer.phone.blank?
        pdf.text customer.email, customer_style unless customer.email.blank?
    end


    pdf.bounding_box([155.mm, 231.mm], :width => 20.mm) do   
        pdf.text "Job Ref:", customer_style
        pdf.text "Quote Ref:", customer_style
        pdf.text "Customer Ref:", customer_style
        pdf.text "Date Issued:", customer_style
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