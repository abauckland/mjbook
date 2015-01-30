module Printtables
  module PrintEmployeeIndex

   # HACK the helper is included in order to allow the formatting of data for processing by prawn
    include ActionView::Helpers::NumberHelper
         
    def employee_column_widths
      [17.mm, 17.mm, 17.mm, 36.mm, 36.mm, 18.mm, 18.mm, 18.mm, 18.mm, 18.mm, 18.mm, 18.mm, 10.mm, 18.mm]
    end
  
    def employee_headers(price_array, total_array)
      ["Ref", "Type", "Job", "Expend. Category", "Supplier", "Supplier Ref:", "Issued Date", "Due Date", "Distance", price_array, "VAT", total_array, "Reciept", "Status"]
    end
  
    def employee_data(data, rows)
        data.each_with_index do |set, i|

          if !set.receipt.blank?
            receipt_confirm = "yes"
          else
            receipt_confirm = ""
          end

          rows[i+1] = [
                       set.ref,
                       set.exp_type,
                       set.project.ref,
                       set.hmrcexpcat.category,
                       set.supplier.company_name,
                       set.supplier_ref,
                       set.date.strftime("%d/%m/%y"),
                       set.due_date.strftime("%d/%m/%y"),
                       set.mileage.distance,
                       number_to_currency(set.price, :unit => "£"),
                       number_to_currency(set.vat, :unit => "£"),
                       number_to_currency(set.total, :unit => "£"),
                       receipt_confirm,
                       set.state
                       ]
        end 
    end
  
  end
end

