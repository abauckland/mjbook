module PrintTable
  extend ActiveSupport::Concern
  include PrintDocumentStyle
  # HACK the helper is included in order to allow the formatting of data for processing by prawn
  include ActionView::Helpers::NumberHelper 

  def table_header(pdf)

    data = [["Category", "Item", "Quantity", "Unit", "Unit Rate", price_array(pdf), "VAT(%)", "VAT", total_array(pdf)]]
    column_widths = [29.mm, 50.mm, 13.mm, 12.mm, 18.mm, 18.mm, 14.mm, 18.mm, 18.mm]
      
    pdf.table(data, 
              :column_widths => column_widths,
              :cell_style => {:padding => [2.mm, 0.mm, 2.mm, 0.mm], :border_width => [0,0,0,0], :size => 8, :align => :left, :font_style => :bold }
              ) do
                values = cells.columns(2..8)                  
                values.align = :right                  
              end        
  end

end