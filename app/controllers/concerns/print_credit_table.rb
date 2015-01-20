module PrintCreditTable
  extend ActiveSupport::Concern
  include PrintTableGroup
  include PrintTableLine

  def credit_table(credit, pdf)   
    pdf.line_width(0.1)
        
    ingroups = Mjbook::Ingroup.joins(:inlines => :creditnoteitems).where('mjbooks_creditnoteitems.creditnote_id' => credit.id)        

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
    
      lines = Mjbook::Inline.joins(:inlines => :creditnoteitems).where('mjbooks_creditnoteitems.creditnote_id' => credit.id, :ingroup_id => group.id)
      lines.each do |line|       
        print_table_item_line(line, sub_price, sub_vat, sub_total, pdf)
      end
    end    
  end

  def group_title_data(ingroup) 
    [[ingroup.group_order, ingroup.text]]
  end

end