module Mjbook
  module CompanyaccountsHelper
    def companyaccount_in_use(companyaccount)      
      expend = Expend.where(:companyaccount_id => companyaccount.id).first
      payment = Payment.where(:companyaccount_id => companyaccount.id).first      
      if expend.blank? && payment.blank?
        true
      end
    end

  end
end
