module QuotesHelper

##specline table formatting
  def line_table(line)
      
      case line.linetype_id
        #products
        when 1 ; "#{line_before_html(line)} #{line_after_html(line)}".html_safe
        #services
        when 2 ; "#{line_before_html(line)} #{line_after_html(line)}".html_safe
        #rate                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
        when 3 ; "#{line_before_html(line)} #{line_after_html(line)}".html_safe
        #misc  
        when 4 ; "#{line_before_html(line)} #{line_after_html(line)}".html_safe
  
      end
  end
  
  def line_before_html(line)
    "<table id='#{line.id}' class='line_table' width='100%'><tr class='line_row'><td class='line_prefix'></td><td class='line_content'>".html_safe  
  end
  
  def line_after_html(line)
    "</tr></table>".html_safe  
  end



#line prefix menues
def group_ref(group)
    "<td class='edit_clause_code'>#{group.ref}</td>".html_safe
end




def line_category(line)
    "<td class='line_category'><span id='#{line.id}' class='qline_cat'>#{line.category.name}</span></td>".html_safe
end

def line_item(line)    
    "<td class='line_item'><span id='#{line.id}' class='qline_item'>#{line.item}</span></td>".html_safe
end

def line_cat_item(line)  
    "<td class='line_cat_item'><span id='#{line.id}' class='qline_cat_item'>#{line.item}</span></td>".html_safe
end

def line_quantity(line)  
    "<td class='line_quantity'><span id='#{line.id}' class='qline_quantity'>#{line.quanity}</span></td>".html_safe
end

def line_unit(line)  
    "<td class='line_quantity'><span id='#{line.id}' class='qline_unit'>#{line.unit}</span></td>".html_safe
end

def line_unit_cost(line)  
    "<td class='line_unit_cost'><span id='#{line.id}' class='qline_rate'>#{pounds(line.unit_cost)}</span>/#{line.unit}</td>".html_safe
end

def line_subtotal(line)  
    "<td class='line_subtotal'>#{pounds(line.subtotal)}</td>".html_safe        
end

def line_vat(line)  
    "<td class='line_vat'><span id='#{line.id}' class='qline_vat'>#{pounds(line.vat)}</span></td>".html_safe
end

def line_price(line)  
    "<td class='line_price'>#{pounds(line.price)}</td>".html_safe      
end

def line_notes(line)  
    "<td colspan='2' class='line_notes'><span id='#{line.id}' class='qline_text'>#{line.text}</span></td>".html_safe
end



  def suffix_group_menu(item)
      "<td class='suffixed_line_menu_mob'>#{mob_menu(line)}</td><td class='suffixed_line_menu' width ='120'>#{group_delete_link(group)}</td></tr><tr class='specline_mob_menu_popup'><td class='mob_line_menu' colspan=2 >#{group_menu_mob(group)}</td></tr>".html_safe
  end
    
  def suffix_line_menu(line)
      "<td class='suffixed_line_menu_mob'>#{mob_menu(line)}</td><td class='suffixed_line_menu' width ='120'>#{line_menu(line)}</tr><tr class='specline_mob_menu_popup'><td class='mob_line_menu' colspan=3 >#{line_menu_mob(line)}</td>".html_safe
  end



  def group_menu(group)
     "#{group_delete_link(group)}#{group_new_link(group)}".html_safe
  end
  
  def group_menu_mob(group)
     "#{group_delete_link(group)}#{group_new_link(group)}".html_safe
  end

  def line_menu(line)
     "<td class='line_menu'>#{line_delete_link(line)}#{line_edit_link(line)}#{line_new_link(line)}</td>".html_safe
  end
  
  def line_menu_mob(line) 
     "#{line_delete_link(line)}#{line_edit_link(line)}#{line_new_link(line)}".html_safe 
  end



  def mob_menu(line)
      image_tag("menu.png", :mouseover =>"menu_rollover.png", :border=>0, :title => 'click for menu')  
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