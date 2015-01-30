module Printtables
  module PrintExpendIndex
   # HACK the helper is included in order to allow the formatting of data for processing by prawn
    include ActionView::Helpers::NumberHelper
     
    def expend_column_widths
      [17.mm, 30.mm, 30.mm, 30.mm, 30.mm, 20.mm, 18.mm, 18.mm, 18.mm, 18.mm, 150.mm]
    end
  
    def expend_headers(price_array, total_array)
      ["Ref", "Expenditure Type", "Expenditure Ref", "Payment Method", "Company Account", "Receipt", "Date",
        price_array, "VAT", total_array, "Receipt", "Status", "Note"]
    end
  
    def expend_data(data, rows)
        data.each_with_index do |set, i|

          if set.business?
            expend_ref = set.expenditem.expense.ref
          elsif set.personal?
            expend_ref = set.expenditem.expense.ref
          elsif set.salary?
            expend_ref = set.expenditem.salary.user.name
          elsif set.transfer?
            expend_ref = ""
          else set.misc?
            expend_ref = ""
          end

          if set.expend_receipt
            receipt_confirm = "yes"
          else
            receipt_confirm = ""
          end

          rows[i+1] = [
                  set.ref,
                  set.exp_type,
                  expend_ref,
                  set.paymethod.text,
                  set.companyaccount.name,
                  set.date.strftime("%d/%m/%y"),
                  number_to_currency(set.price, :unit => "£"),
                  number_to_currency(set.vat_due, :unit => "£"),
                  number_to_currency(set.total, :unit => "£"),
                  receipt_confirm,
                  set.state,
                  set.note
                       ]
        end 
    end
  
  end
end