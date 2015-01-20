module PrintIndexTable
 
 # HACK the helper is included in order to allow the formatting of data for processing by prawn
  include Printtables::PrintBusinessIndex
  include Printtables::PrintCustomerIndex
  include Printtables::PrintEmployeeIndex
  include Printtables::PrintExpendIndex
  include Printtables::PrintInvoiceIndex
  include Printtables::PrintMileageIndex
  include Printtables::PrintMiscIndex
  include Printtables::PrintPaymentIndex
  include Printtables::PrintPersonalIndex
  include Printtables::PrintProductIndex
  include Printtables::PrintProjectIndex
  include Printtables::PrintQuoteIndex
  include Printtables::PrintSalaryIndex
  include Printtables::PrintServiceIndex
  include Printtables::PrintSupplierIndex
  include Printtables::PrintTermIndex
    
  def index_table(data, index, pdf)   
         
    pdf.bounding_box [0.mm, 170.mm], :width => 277.mm, :height => 155.mm do
      pdf.stroke_bounds  
      table_contents(data, index, pdf)          
    end
     
  end


  def table_contents(data, index, pdf) 

  #font styles for page  
    table_style = {:size => 8}
  #formating for lines  
    table_format = table_style.merge(:align => :left)

    rows = []           
    rows[0] = header_content(index, pdf)             
    table_data(index, data, rows, pdf)   
        
    pdf.table(rows, :header => true, 
                    :column_widths => column_widths(index),
                    :cell_style => {:padding => [2.mm, 2.mm, 2.mm, 2.mm], :border_width => [0,0,0,0], :size => 8}
                    ) do
                      row(0).font_style = :bold
                      row(0).size = 8 
                      row(0).border_width = [0,0,1,0]                                          
                    end         
  end


  def table_data(index, data, rows, pdf)
    case index
      #table columns: 
      when 'business' ; business_data(data, rows) 
      when 'customer' ; customer_data(data, rows, pdf) 
      when 'employee' ; employee_data(data, rows)      
      when 'expend' ; expend_data(data, rows)      
      when 'invoice' ; invoice_data(data, rows) 
      when 'mileage' ; mileage_data(data, rows) 
      when 'payment' ; payment_data(data, rows)         
      when 'personal' ; personal_data(data, rows)        
      when 'product' ; product_data(data, rows) 
      when 'service' ; service_data(data, rows)
      when 'misc' ; misc_data(data, rows)        
      when 'project' ; project_data(data, rows)        
      when 'quote' ; quote_data(data, rows)       
      when 'salary' ; salary_data(data, rows)                              
      when 'supplier' ; supplier_data(data, rows, pdf) 
      when 'quoteterm' ; term_data(data, rows) 
      when 'invoiceterm' ; term_data(data, rows)
    end    
  end

  def column_widths(index)
    case index
      #table columns: 
      when 'business' ; business_column_widths 
      when 'customer' ; customer_column_widths
      when 'employee' ; employee_column_widths       
      when 'expend' ; expend_column_widths       
      when 'invoice' ; invoice_column_widths
      when 'mileage' ; mileage_column_widths 
      when 'payment' ; payment_column_widths         
      when 'personal' ; personal_column_widths        
      when 'product' ; product_column_widths 
      when 'service' ; service_column_widths
      when 'misc' ; misc_column_widths
      when 'project' ; project_column_widths        
      when 'quote' ; quote_column_widths        
      when 'salary' ; salary_column_widths                              
      when 'supplier' ; supplier_column_widths
      when 'quoteterm' ; term_column_widths
      when 'invoiceterm' ; term_column_widths
    end    
  end


  def header_content(index, pdf)
    
    price_array = pdf.make_table([["Price"], ["(ex VAT)"]],
                                 :cell_style => {:padding => [0.mm, 0.mm, 0.mm, 0.mm], :border_width => [0,0,0,0], :size => 8}
                                 ) do 
                                    row(0).font_style = :bold
                                    row(0).size = 8 
                                    row(1).size = 6      
                                 end
    
    total_array = pdf.make_table([["Total"], ["(inc VAT)"]],
                                 :cell_style => {:padding => [0.mm, 0.mm, 0.mm, 0.mm], :border_width => [0,0,0,0], :size => 8}
                                 ) do 
                                    row(0).font_style = :bold
                                    row(0).size = 8 
                                    row(1).size = 6      
                                 end
    
    case index
      #table columns: 
      when 'business' ; business_headers(price_array, total_array) 
      when 'customer' ; customer_headers
      when 'employee' ; employee_headers(price_array, total_array)       
      when 'expend' ; expend_headers(price_array, total_array)       
      when 'invoice' ; invoice_headers(price_array, total_array) 
      when 'mileage' ; mileage_headers
      when 'payment' ; payment_headers(price_array, total_array)       
      when 'personal' ; personal_headers(price_array, total_array)        
      when 'product' ; product_headers(price_array, total_array)  
      when 'service' ; service_headers(price_array, total_array) 
      when 'misc' ; misc_headers        
      when 'project' ; project_headers       
      when 'quote' ; quote_headers(price_array, total_array)        
      when 'salary' ; salary_headers                              
      when 'supplier' ; supplier_headers
      when 'quoteterm' ; term_headers
      when 'invoiceterm' ; term_headers
    end    
  end


end