module PrintInvoiceTable
  extend ActiveSupport::Concern
  include PrintTableGroup
  include PrintTableLine

  def invoice_table(quote, pdf)   
    pdf.line_width(0.1)
    ingroups = Mjbook::Ingroup.where(:invoice_id => invoice.id)         

 #   pdf.bounding_box([0.mm, 180.mm], :width => 190.mm, :height => 140.mm) do        
 #   pdf.stroke_bounds    
    ingroups.each do |group|
    
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
    
      lines = Mjbook::Inline.where(:ingroup_id => group.id)
      lines.each do |line|       
        print_table_item_line(line) 
      end
      group_subtotal_table(group, pdf)
    end    
  end


  def group_title_data(ingroup) 
    [[ingroup.group_order, ingroup.text]]
  end  
  
  def group_title_options    
    {
    :column_widths => [5.mm, 185.mm],
    :cell_style => {:padding => [2.mm, 0.mm, 2.mm, 0.mm], :border_width => [0,0,0,0], :size => 8, :align => :left, :font_style => :bold}
    }
  end   

  def draft_group_title_table(ingroup, pdf)     
     @draft_title_table = pdf.make_table(group_title_data(ingroup), group_title_options) 
  end

  def group_title_table(ingroup, pdf) 
    pdf.table(group_title_data(ingroup), group_title_options) 
  end


  
  def group_total_data(qgroup) 
    [["", "Subtotal", number_to_currency(ingroup.price, :unit => "£"), "", number_to_currency(ingroup.vat_due, :unit => "£"), number_to_currency(ingroup.total, :unit => "£")]]
  end  
  
  def group_total_options    
    {
    :column_widths => [8.mm, 114.mm, 18.mm, 14.mm, 18.mm, 18.mm],
    :cell_style => {:padding => [2.mm, 0.mm, 5.mm, 0.mm], :border_width => [0,0,0,0], :size => 8}
    }
  end

  def draft_group_subtotal_table(ingroup, pdf)
      @draft_total_table = pdf.make_table(group_total_data(ingroup), group_total_options)       
  end

  def group_subtotal_table(ingroup, pdf)      
    pdf.table(group_total_data(ingroup), group_total_options) do
              values = cells.columns(1..5)                  
              values.align = :right                  
    end         
  end



end