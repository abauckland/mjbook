module PrintHeader
  extend ActiveSupport::Concern
  include PrintDocumentStyle

  def company_header(pdf)
    
    pdf.bounding_box([0.mm, 265.mm], :width => 95.mm, :height => 20.mm) do
        pdf.text current_user.company.name, company_style unless current_user.company.name.blank?
        pdf.text current_user.company.address_1, company_style unless current_user.company.address_1.blank?
        pdf.text current_user.company.address_2, company_style unless current_user.company.address_2.blank?
        pdf.text current_user.company.city, company_style unless current_user.company.city.blank?
        pdf.text current_user.company.county, company_style unless current_user.company.county.blank?
        pdf.text current_user.company.postcode, company_style unless current_user.company.postcode.blank?
    end

    pdf.bounding_box([0.mm, 243.mm], :width => 95.mm, :height => 12.mm) do
        pdf.text current_user.company.email, company_style unless current_user.company.email.blank?
        pdf.text current_user.company.www, company_style unless current_user.company.www.blank?
    end

    pdf.bounding_box([155.mm, 265.mm], :width => 50.mm, :height => 20.mm) do
        pdf.text "Tel: "+current_user.company.tel, company_style unless current_user.company.tel.blank?
        pdf.text "Mob: "+current_user.company.alt_tel, company_style unless current_user.company.alt_tel.blank?
    end

    pdf.bounding_box([155.mm, 243.mm], :width => 50.mm, :height => 12.mm) do
        pdf.text "Reg No: #{current_user.company.reg_no}", company_style unless current_user.company.reg_no.blank?
        pdf.text "VAT No: #{current_user.company.vat_no}", company_style unless current_user.company.vat_no.blank?
    end

    pdf.line_width(0.1)

    pdf.stroke do
      pdf.line [0.mm, 234.mm],[190.mm, 234.mm]
    end
    
  end  

end