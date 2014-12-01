module Mjbook
  module ExpendsHelper
    def expend_expenses(expend_id)
      expense = Mjbook::Expense.joins(:expenditems).where('mjbook_expenditems.expend_id' => expend_id).first
      return expense.supplier.company_name
    end
  end
end
