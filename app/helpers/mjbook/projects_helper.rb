module Mjbook
  module ProjectsHelper
    
    def project_in_use(project)      
      project_expense = Expense.where(:project_id => product.id).first      
      project_mileage = Mileage.where(:project_id => product.id).first
      project_expend = Expend.where(:project_id => product.id).first      
      project_invoice = Invoice.where(:project_id => product.id).first      
      project_quote = Quote.where(:project_id => product.id).first      
      project_payment = Payment.where(:project_id => product.id).first      
      
      if product_expense.blank? && project_mileage.blank? && project_expend.blank? && project_invoice.blank? && project_quote.blank? && project_payment.blank?
        true
      end  
    end
      
    
  end
end
