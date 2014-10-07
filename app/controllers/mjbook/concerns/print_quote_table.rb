module PrintQuoteTable

  def quote_table(quote, pdf)   

    qgroups = Qgoup.where(:quote_id => quote.id)         
        
    qgroups.each do |qgroup|
      pdf.group do
    
        group_title_table(qgroup, pdf)
        
        lines = Qline.where(:qgroup_id => qgroup.id).orders(:line_order)
        lines.each do |line|            
          line_item_table(line, pdf)                    
        end                
        group_subtotal_table(qgroup, pdf)                       
      end    
    end      
  end


  def group_title_table(qgroup, pdf) 
      
      data = [qgroup.ref, qgroup.text]
      column_widths = [5.mm, 190.mm]
      
      pdf.table(data,
                :row_colors => ["#ffffff", "bbbbbb"], 
                :column_widths => column_widths,
                :cell_style => {:padding => [5, 5, 6, 5], :border_width => [0,0,0,0], :size => 8}
                ) 
  end

  def group_subtotal_table(qgroup, pdf)
      data = ["", qgroup.sub_vat, qgroup.sub_price]
      column_widths = [150.mm, 20.mm, 20.mm]
      
      pdf.table(data,
                :row_colors => ["#ffffff", "bbbbbb"], 
                :column_widths => column_widths,
                :cell_style => {:padding => [5, 5, 6, 5], :border_width => [0,0,0,0], :size => 8}
                )     
  end

  def line_item_table(line, pdf)    
      case line.linetype_id
        #products
      when 1 ; line_product_table(line, pdf)
        #services & rate
        when 2,3 ; line_service_table(line, pdf) 
        #misc  
        when 4 ; line_misc_table(line, pdf)  
      end        
  end

  def line_product_table(line, pdf)
      data = ["", line.cat, line.item, line.quantity, line.rate, line.vat_rate.rate, line.vat, line.price]
      column_widths = [5.mm, 40.mm, 60.mm, 10.mm, 10.mm, 10.mm, 10.mm, 10.mm]
      
      pdf.table(data,
                :row_colors => ["#ffffff", "bbbbbb"], 
                :column_widths => column_widths,
                :cell_style => {:padding => [5, 5, 6, 5], :border_width => [0,0,0,0], :size => 8}
                )     
  end
  
  def line_service_table(line, pdf) 
      data = [["", line.cat, line.item, line.quantity, line.rate, line.vat_rate.rate, line.vat, line.price], [{:content => line.note, :colspan => 9}]]
      column_widths = [5.mm, 40.mm, 60.mm, 10.mm, 10.mm, 10.mm, 10.mm, 10.mm]
      
      pdf.table(data,
                :row_colors => ["#ffffff", "bbbbbb"], 
                :column_widths => column_widths,
                :cell_style => {:padding => [5, 5, 6, 5], :border_width => [0,0,0,0], :size => 8}
                )    
  end
  
  def line_misc_table(line, pdf) 
      data = [["", line.cat, line.item], [{:content => line.note, :colspan => 3}]]
      column_widths = [5.mm, 40.mm, 145.mm]
      
      pdf.table(data,
                :row_colors => ["#ffffff", "bbbbbb"], 
                :column_widths => column_widths,
                :cell_style => {:padding => [5, 5, 6, 5], :border_width => [0,0,0,0], :size => 8}
                )     
  end

end