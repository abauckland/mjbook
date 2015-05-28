module Mjbook
  module ProjectsHelper

    def project_in_use(project)
      expense = Expense.where(:project_id => project.id).first
      mileage = Mileage.where(:project_id => project.id).first
      invoice = Invoice.where(:project_id => project.id).first
      quote = Quote.where(:project_id => project.id).first
      
      if expense.blank? && mileage.blank? && invoice.blank? && quote.blank?
        false
      end
    end


  end
end
