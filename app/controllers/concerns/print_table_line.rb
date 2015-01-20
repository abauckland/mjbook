module PrintTableLine
  # HACK the helper is included in order to allow the formatting of data for processing by prawn
  include ActionView::Helpers::NumberHelper 

  def print_table_item_line(line, sub_price, sub_vat, sub_total, pdf)
    #draft line table & get new location
    draft_line_item_table(line,pdf)
    current_location = pdf.y - @draft_line_table.height
    
    if current_location >= 50.mm        
      #draw table
      line_item_table(line, pdf)
      #update values
      sub_price += line.price
      sub_vat += line.vat_due
      sub_total += line.total
    else
      #draw summary of costs
      group_page_break(sub_price, sub_vat, sub_total, pdf)
      pdf.start_new_page
      pdf.y = 182.mm
      table_header(pdf)
      #carried over table
      group_page_continuation(sub_price, sub_vat, sub_total, pdf)
      #draw table
      line_item_table(line, pdf)
      #reset subtotal values
      sub_price = 0
      sub_vat = 0
      sub_total = 0
    end
  end
  
  def group_page_break_options    
    {
      :column_widths => [50.mm, 18.mm, 18.mm, 18.mm],
      :cell_style => {:padding => [2.mm, 0.mm, 2.mm, 0.mm], :border_width => [0,0,0,0], :size => 7, :align => :left, :font_style => :italic }
    }
  end

  def group_page_break(sub_price, sub_vat, sub_total, pdf)
    
    data = [['Item continued on next page', number_to_currency(sub_price, :unit => "£"), number_to_currency(sub_vat, :unit => "£"), number_to_currency(sub_total, :unit => "£")]]
    pdf.table(data, group_page_break_options)
  
  end
  
  def group_page_continuation(sub_price, sub_vat, sub_total, pdf)

    data = [['Item continued from previous page', number_to_currency(sub_price, :unit => "£"), number_to_currency(sub_vat, :unit => "£"), number_to_currency(sub_total, :unit => "£")]]
    pdf.table(data, group_page_break_options)  
  
  end


  def draft_line_item_table(line, pdf)
      case line.linetype
        #products
      when 1 ; draft_line_product_table(line, pdf)
        #services & rate
        when 2 ; draft_line_service_table(line, pdf) 
        #misc  
        when 3 ; draft_line_misc_table(line, pdf)  
      end      
  end


  def line_item_table(line, pdf)    
      case line.linetype
        #products
        when 1 ; line_product_table(line, pdf)
        #services & rate
        when 2 ; line_service_table(line, pdf) 
        #misc  
        when 3 ; line_misc_table(line, pdf)  
      end        
  end


  def product_table_data(line) 
      #[["", line.cat, line.item, line.quantity, line.unit.text, line.rate, line.vat.rate, line.vat_due, line.price]]
      [[
        "-",
        line.cat,
        line.item,
        line.quantity,
        line.unit.text,
        number_to_currency(line.rate, :unit => "£"),
        number_to_currency(line.price, :unit => "£"),
        line.vat.cat,
        number_to_currency(line.vat_due, :unit => "£"),
        number_to_currency(line.total, :unit => "£")
        ]]
  end  
  
  def product_table_options    
    {
      :column_widths => [3.mm, 26.mm, 50.mm, 13.mm, 12.mm, 18.mm, 18.mm, 14.mm, 18.mm, 18.mm],
      :cell_style => {:padding => [2.mm, 0.mm, 2.mm, 0.mm], :border_width => [0,0,0,0], :size => 8, :align => :left }
    }
  end

  def draft_line_product_table(line, pdf)      
      @draft_line_table = pdf.make_table(product_table_data(line), product_table_options)   
  end

  def line_product_table(line, pdf)      
      pdf.table(product_table_data(line), product_table_options) do
                  values = cells.columns(3..9)                  
                  values.align = :right                  
                end    
  end



  def service_table_data(line) 
      [[
        "-",
        line.cat,
        line.item,
        "",
        "",
        "",
        number_to_currency(line.price, :unit => "£"),
        line.vat.cat,
        number_to_currency(line.vat_due, :unit => "£"),
        number_to_currency(line.total, :unit => "£")
        ]]
  end  
  
  def service_table_options    
    {
      :column_widths => [3.mm, 26.mm, 50.mm, 13.mm, 12.mm, 18.mm, 18.mm, 14.mm, 18.mm, 18.mm],
      :cell_style => {:padding => [2.mm, 0.mm, 2.mm, 0.mm], :border_width => [0,0,0,0], :size => 8, :align => :left }
    }
  end

  def draft_line_service_table(line, pdf)      
      @draft_line_table = pdf.make_table(service_table_data(line), service_table_options)   
  end

  def line_service_table(line, pdf)      
      pdf.table(service_table_data(line), service_table_options) do
                  values = cells.columns(3..9)                  
                  values.align = :right                  
                end    
  end



  def misc_table_data(line) 
      #[["", line.cat, line.item, line.quantity, line.unit.text, line.rate, line.vat.rate, line.vat_due, line.price]]
      [[
        "-",
        line.cat,
        line.item,
        "",
        "",
        "",
        "",
        "",
        "",
        ""
        ]]
  end  
  
  def misc_table_options    
    {
      :column_widths => [3.mm, 26.mm, 50.mm, 13.mm, 12.mm, 18.mm, 18.mm, 14.mm, 18.mm, 18.mm],
      :cell_style => {:padding => [2.mm, 0.mm, 2.mm, 0.mm], :border_width => [0,0,0,0], :size => 8, :align => :left }
    }
  end

  def draft_line_misc_table(line, pdf)      
      @draft_line_table = pdf.make_table(misc_table_data(line), misc_table_options)   
  end

  def line_misc_table(line, pdf)      
      pdf.table(misc_table_data(line), misc_table_options) do
                  values = cells.columns(3..9)                  
                  values.align = :right                  
                end    
  end


end