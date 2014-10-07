module QuotesHelper

def quote_vat(group)
  vat = 0
  return "#{pounds(vat)}".html_safe 
end

def quote_price(group)
  price = 0
  return "#{pounds(price)}".html_safe 
end



def group_vat(group)
  vat = 0
  return "#{pounds(vat)}".html_safe 
end

def group_price(group)
  price = 0
  return "#{pounds(price)}".html_safe 
end
##specline table formatting

#  def line_table(line)
#    "#{line_before_html(line)}#{line_content(line)}#{line_after_html(line)}".html_safe     
#  end
  
#  def line_before_html(line)
#    "<table id='#{line.id}' class='line_table' width='100%'><tr class='line_row'><td class='line_prefix'></td><td class='line_content'>".html_safe  
#  end
  
#  def line_after_html(line)
#    "</td>#{suffix_line_menu(line)}</tr></table>".html_safe  
#  end

  def line_content(line)
      
      case line.linetype_id
        #products
        when 1 ; render :partial => 'product_line', locals: { line: line }
        #services & rate
        when 2,3 ; render :partial => 'service_line', locals: { line: line }
        #misc  
        when 4 ; render :partial => 'misc_line', locals: { line: line }  
      end
  end


  def line_category(line)
      "<span id='#{line.id}' class='qline_cat'>#{line.category.name}</span>".html_safe
  end
  
  def line_item(line)    
      "<span id='#{line.id}' class='qline_item'>#{line.item}</span>".html_safe
  end
  
  def line_cat_item(line)  
      "<td class='line_cat_item'><span id='#{line.id}' class='qline_cat_item'>#{line.item}</span>".html_safe
  end
  
  def line_quantity(line)  
      "<span id='#{line.id}' class='qline_quantity'>#{line.quanity}</span>".html_safe
  end
  
  def line_rate(line)  
      "<span id='#{line.id}' class='qline_rate'>#{pounds(line.unit_cost)}</span>/#{line.unit}".html_safe
  end
  
  def line_unit(line)  
      "<span id='#{line.id}' class='qline_unit'>#{line.unit}</span>".html_safe
  end
  
  def line_vat_rate(line)
      "<span id='#{line.id}' class='qline_vat_rate'>#{line.vat.rate}</span>".html_safe
  end
  
  def line_vat(line)  
      "<span id='#{line.id}' class='qline_vat'>#{pounds(line.vat)}</span>".html_safe
  end
  
  def line_price(line)  
      "#{pounds(line.price)}".html_safe      
  end
  
  def line_note(line)  
      "<span id='#{line.id}' class='qline_text'>#{line.text}</span>".html_safe
  end



  def suffix_group_menu(group)
      "<td class='line_menu_mob'>#{mob_menu}</td><td class='line_menu'>#{group_menu_items(group)}</td></tr><tr class='mob_menu_popup'><td class='mob_line_menu' colspan=3 >#{group_menu_items(group)}</td></tr>".html_safe
  end
    
  def suffix_line_menu(line)
      "<td class='ine_menu_mob'>#{mob_menu}</td><td class='line_menu'>#{line_menu_items(line)}</tr><tr class='mob_menu_popup'><td class='mob_line_menu' colspan=3 >#{line_menu_items(line)}</td>".html_safe
  end



  def group_menu_items(group)
     "#{group_delete_link(group)}#{group_new_link(group)}".html_safe
  end

  def line_menu_items(line)
     "#{line_delete_link(line)}#{line_edit_link(line)}#{line_new_link(line)}".html_safe
  end



  def mob_menu
    link_to "", nil, :class => "row_menu_button", :title => "click for menu"  
  end

  def group_new_link(group)
    link_to "", new_group_path(group), :class => "row_insert_button", :title => "add section"
  end
    
  def group_delete_link(group)
    link_to "", group, method: :delete, :class => "line_delete_icon", :title => "delete section"
  end
    
  def line_new_link(line)
    link_to "", new_qline_path(line.id), :class => "line_insert_icon", :title => "insert new item"
  end
    
  def line_edit_link(line)
    link_to "", edit_qline_path(line.id), :class => "line_edit_icon", :title => "change item type"
  end
    
  def line_delete_link(line)
    link_to "", line, method: :delete, :class => "line_delete_icon", :title => "delete item"
  end

end