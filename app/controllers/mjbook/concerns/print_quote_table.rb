module PrintQuoteTable

  # HACK the helper is included in order to allow the formatting of data for processing by prawn
  include ActionView::Helpers::NumberHelper 

  def table_header(pdf)
    price_array = pdf.make_table([["Price"], ["(ex VAT)"]],
                                 :column_widths => [18.mm],
                                 :cell_style => {:padding => [0.mm, 0.mm, 0.mm, 0.mm], :border_width => [0,0,0,0], :size => 8, :align => :right}
                                 ) do 
                                    row(0).font_style = :bold
                                    row(0).size = 8 
                                    row(1).size = 6      
                                 end
    
    total_array = pdf.make_table([["Total"], ["(inc VAT)"]],
                                 :column_widths => [18.mm],
                                 :cell_style => {:padding => [0.mm, 0.mm, 0.mm, 0.mm], :border_width => [0,0,0,0], :size => 8, :align => :right}
                                 ) do 
                                    row(0).font_style = :bold
                                    row(0).size = 8 
                                    row(1).size = 6      
                                 end

    data = [["Category", "Item", "Quantity", "Unit", "Unit Rate", price_array, "VAT(%)", "VAT", total_array]]
    column_widths = [29.mm, 50.mm, 13.mm, 12.mm, 18.mm, 18.mm, 14.mm, 18.mm, 18.mm]
      
    pdf.table(data, 
              :column_widths => column_widths,
              :cell_style => {:padding => [2.mm, 0.mm, 2.mm, 0.mm], :border_width => [0,0,0,0], :size => 8, :align => :left, :font_style => :bold }
              ) do
                values = cells.columns(2..8)                  
                values.align = :right                  
              end        
  end


  def quote_table(quote, pdf)   
    pdf.line_width(0.1)
    qgroups = Mjbook::Qgroup.where(:quote_id => quote.id)         

 #   pdf.bounding_box([0.mm, 180.mm], :width => 190.mm, :height => 140.mm) do        
 #   pdf.stroke_bounds
    
    qgroups.each do |group|
    
#THIS WILL CAUSE NEW PAGE TO BE STARTED
      if pdf.y <= 60.mm
        #height where still space for title, line and subtotal
        pdf.start_new_page
        pdf.y = 182.mm
      end
    
      group_title_table(group, pdf)
    
      #draw table group
      sub_price = 0
      sub_vat = 0
      sub_total = 0
    
      lines = Mjbook::Qline.where(:qgroup_id => group.id)
      lines.each do |line|
        #draft line table & get new location
        draft_line_item_table(line, pdf)
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
      group_subtotal_table(group, pdf)
    end
    
  end
  
  def group_page_break_options    
    {
      :column_widths => [50.mm, 18.mm, 18.mm, 18.mm],
      :cell_style => {:padding => [2.mm, 0.mm, 2.mm, 0.mm], :border_width => [0,0,0,0], :size => 7, :align => :left, :font_style => :italic }
    }
  end

  def group_page_break(sub_price, sub_vat, sub_total, pdf)
    
    data = [['Quote item continued on next page', number_to_currency(sub_price, :unit => "£"), number_to_currency(sub_vat, :unit => "£"), number_to_currency(sub_total, :unit => "£")]]
    pdf.table(data, group_page_break_options)
  
  end
  
  def group_page_continuation(sub_price, sub_vat, sub_total, pdf)

    data = [['Quote item continued from previous page', number_to_currency(sub_price, :unit => "£"), number_to_currency(sub_vat, :unit => "£"), number_to_currency(sub_total, :unit => "£")]]
    pdf.table(data, group_page_break_options)  
  
  end





  def group_title_data(qgroup) 
    [[qgroup.group_order, qgroup.text]]
  end  
  
  def group_title_options    
    {
    :column_widths => [5.mm, 185.mm],
    :cell_style => {:padding => [2.mm, 0.mm, 2.mm, 0.mm], :border_width => [0,0,0,0], :size => 8, :align => :left, :font_style => :bold}
    }
  end   

  def draft_group_title_table(qgroup, pdf)     
     @draft_title_table = pdf.make_table(group_title_data(qgroup), group_title_options) 
  end

  def group_title_table(qgroup, pdf) 
    pdf.table(group_title_data(qgroup), group_title_options) 
  end


  
  def group_total_data(qgroup) 
    [["", "Subtotal", number_to_currency(qgroup.price, :unit => "£"), "", number_to_currency(qgroup.vat_due, :unit => "£"), number_to_currency(qgroup.total, :unit => "£")]]
  end  
  
  def group_total_options    
    {
    :column_widths => [8.mm, 114.mm, 18.mm, 14.mm, 18.mm, 18.mm],
    :cell_style => {:padding => [2.mm, 0.mm, 5.mm, 0.mm], :border_width => [0,0,0,0], :size => 8}
    }
  end

  def draft_group_subtotal_table(qgroup, pdf)
      @draft_total_table = pdf.make_table(group_total_data(qgroup), group_total_options)       
  end

  def group_subtotal_table(qgroup, pdf)      
    pdf.table(group_total_data(qgroup), group_total_options) do
              values = cells.columns(1..5)                  
              values.align = :right                  
    end         
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