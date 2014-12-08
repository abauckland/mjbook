class PaymentMailer < ActionMailer::Base
  
#  default from: current_user.email

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def reciept(payment)

#    reciept_subject = "Reciept" << payment.ref << payment.date

#    mail :to => payment.customer.email, :subject => reciept_subject
    
    
    
  end
  
end