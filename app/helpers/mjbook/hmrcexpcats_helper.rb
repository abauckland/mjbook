module Mjbook
  module HmrcexpcatsHelper

    def hmrcexpcat_in_use(hmrcexpcat)
      category = Expense.where(:hmrcexpcat_id => hmrcexpcat.id).first
      if category.blank?
        true
      end
    end


  end
end
