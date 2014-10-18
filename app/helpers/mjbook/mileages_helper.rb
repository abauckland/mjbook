module Mjbook
  module MileagesHelper
    
    def mileage_in_use(mileage)      
      mileage = Expense.where(:mileage_id => mileage.id).first      
      if mileage.blank?
        true
      end  
    end
      
    
  end
end
