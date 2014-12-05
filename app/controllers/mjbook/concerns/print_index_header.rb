module PrintIndexHeader

  def index_header(index, filter_group, date_from, date_to, pdf)  
    
    pdf.line_width(0.1)
        
    header_contents(index, filter_group, date_from, date_to, pdf)
          
    pdf.stroke do
      pdf.line [0.mm, 175.mm],[277.mm, 175.mm]
    end
  end


  def header_contents(index, filter_group, date_from, date_to, pdf)
    
    company = ::Company.where(:id => current_user.company_id).first
  #font styles for page  
    header_style = {:size => 8}  
  #formating for lines  
    header_format = header_style.merge(:align => :left)
    
  #header layout
    pdf.text header_title(index), :size => 20
    pdf.text header_filter_group(filter_group), header_format
    pdf.text "Date From: #{ date_from }", header_format
    pdf.text "Date To: #{ date_to }", header_format
         
   # pdf.image company.logo, :position => :right, :vposition => -12.mm, :align => :right, :fit => [250,25]        
  end

  def header_title(index)
    case index
      #table columns: 
      when 'business' ; "Business Expenses"
      when 'customer' ; "Customers"
      when 'employee' ; "Employee Expenses"
      when 'expend' ; "Expenditure"
      when 'invoice' ; "Inovices"
      when 'mileage' ; "Mileage Expenses"
      when 'payment' ; "Payments"
      when 'personal' ; "Personal Expenses"
      when 'product' ; "Products/Services (variable sum)"
      when 'service' ; "Services (lump sum)"
      when 'misc' ; "Miscellaneous Services/Products"
      when 'project' ; "Jobs"
      when 'quote' ; "Quotes"
      when 'salary' ; "Salary Payements"
      when 'supplier' ; "Suppliers"
      when 'quoteterm' ; "QuoteTerms"
      when 'inoviceterm' ; "Inovice Terms"
    end    
  end

  def header_filter_group(filter_group)
    case filter_group
      #table columns: 
      when 'business' ; "Supplier: #{ filter_group }"
      when 'customer' ; ""
      when 'employee' ; "Job: #{ filter_group }"
      when 'expend' ; ""
      when 'invoice' ; "Customer: #{ filter_group }"
      when 'mileage' ; ""
      when 'payment' ; "Customer: #{ filter_group }"
      when 'personal' ; "Employee: #{ filter_group }"
      when 'product' ; ""
      when 'service' ; ""
      when 'misc' ; ""
      when 'project' ; ""
      when 'quote' ; "Customer: #{ filter_group }"
      when 'salary' ; "Employee: #{ filter_group }"
      when 'supplier' ; ""
      when 'quoteterm' ; ""
      when 'invoiceterm' ; ""
    end    
  end


end
