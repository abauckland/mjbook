module Mjbook
  module SuppliersHelper

    def supplier_in_use(supplier)
      supplier = Expense.where(:supplier_id => supplier.id).first      
      if !supplier.blank?
        false
      else
        true
      end
    end

  end
end