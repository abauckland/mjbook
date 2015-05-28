module Mjbook
  module InvoicesHelper

  def invoice_price(groups)
    price = Inline.where(:ingroup_id => groups.ids).sum(:price)
    return "#{ pounds(price) }".html_safe 
  end

  def invoice_vat(groups)
    vat_due = Inline.where(:ingroup_id => groups.ids).sum(:vat_due)
    return "#{ pounds(vat_due) }".html_safe 
  end

  def invoice_total(groups)
   total = Inline.where(:ingroup_id => groups.ids).sum(:total)
    return "#{ pounds(total) }".html_safe 
  end


  def ingroup_price(group)
    price = Inline.where(:ingroup_id => group.id).sum(:price)
    return "#{ pounds(price) }".html_safe 
  end

  def ingroup_vat(group)
    vat_due = Inline.where(:ingroup_id => group.id).sum(:vat_due)
    return "#{ pounds(vat_due) }".html_safe 
  end

  def ingroup_total(group)
    total = Inline.where(:ingroup_id => group.id).sum(:total)
    return "#{ pounds(total) }".html_safe 
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

    def inline_content(line)

        case line.linetype
          #products
          when 1 ; render :partial => 'in_product_line', locals: { line: line }
          #services & rate
          when 2 ; render :partial => 'in_service_line', locals: { line: line }
          #misc  
          when 3 ; render :partial => 'in_misc_line', locals: { line: line }
        end
    end


    def inline_category(line)
        "<span id='#{ line.id }' class='inline_cat'>#{ line.cat }</span>".html_safe
    end

    def inline_item(line)
        "<span id='#{ line.id }' class='inline_item'>#{ line.item }</span>".html_safe
    end

    def inline_cat_item(line)
        "<span id='#{ line.id }' class='inline_cat_item'>#{ line.item }</span>".html_safe
    end

    def inline_quantity(line)
        "<span id='#{ line.id }' class='inline_quantity'>#{ line.quantity }</span>".html_safe
    end

    def inline_rate(line)
        "<span id='#{ line.id }' class='inline_rate'>#{ pounds_no_unit(line.rate) }</span>".html_safe
    end

    def inline_unit(line)
        "<span id='#{ line.id }' class='inline_unit'>#{ line.unit.text }</span>".html_safe
    end

    def inline_price(line)
        "<span id='#{ line.id }' class='inline_price'>#{ pounds(line.price) }".html_safe      
    end

    def inline_vat_rate(line)
        "<span id='#{ line.id }' class='inline_vat_rate'>#{ line.vat.rate }%</span>".html_safe
    end

    def inline_note(line)  
        "<span id='#{ line.id }' class='inline_text'>#{ line.note }</span>".html_safe
    end


    def auto_inline_price(line)
        "<span id='#{ line.id }' class='auto_inline_price'>#{ pounds(line.price) }".html_safe      
    end

    def auto_inline_vat(line)
        "<span id='#{ line.id }' class='auto_inline_vat'>#{ pounds(line.vat_due) }</span>".html_safe
    end

    def auto_inline_total(line)  
        "<span id='#{ line.id }' class='auto_inline_total'>#{ pounds(line.total) }".html_safe      
    end


    def suffix_ingroup_menu(group)
        "<td class='line_menu_mob'>#{ in_mob_menu }</td><td class='line_menu'>#{ ingroup_menu_items(group) }</td></tr><tr class='mob_menu_popup'><td class='mob_line_menu' colspan=3 >#{ ingroup_menu_items(group) }</td></tr>".html_safe
    end
      
    def suffix_inline_menu(line)
        "<td class='line_menu_mob'>#{in_mob_menu }</td><td class='line_menu'>#{ inline_menu_items(line) }</tr><tr class='mob_menu_popup'><td class='mob_line_menu' colspan=3 >#{ inline_menu_items(line) }</td>".html_safe
    end
  
  
  
    def ingroup_menu_items(group)
       "#{ ingroup_new_link(group) }#{ ingroup_delete_link(group) }".html_safe
    end

    def inline_menu_items(line)
       "#{ inline_new_link(line) }#{ inline_edit_link(line) }#{ inline_delete_link(line) }".html_safe
    end



    def in_mob_menu
      link_to "", nil, :class => "line_menu_icon", :title => "click for menu"
    end

    def ingroup_new_link(group)
      link_to "", new_group_ingroup_path(group.id), :method => :get,  :remote => true, :class => "line_new_icon", :title => "add section"
    end

    def ingroup_delete_link(group)
      if Ingroup.where(:invoice_id =>  group.invoice_id).size >= 2
        link_to "", delete_group_ingroup_path(group.id), :method => :get,  :remote => true, :class => "line_delete_icon", :title => "delete section"
      end
    end

    def inline_new_link(line)
      link_to "", new_line_inline_path(line.id), :method => :get,  :remote => true, :class => "line_insert_icon", :title => "insert new item"
    end

    def inline_edit_link(line)
      link_to "", edit_line_inline_path(line.id), :method => :get,  :remote => true, :class => "line_edit_icon", :title => "change item type"
    end

    def inline_delete_link(line)
      if Inline.where(:ingroup_id =>  line.ingroup_id).size >= 2
        link_to "", delete_line_inline_path(line.id), :method => :get,  :remote => true, :class => "line_delete_icon", :title => "delete item"
      end
    end
  end
end