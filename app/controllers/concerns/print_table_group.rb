module PrintTableGroup


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



end