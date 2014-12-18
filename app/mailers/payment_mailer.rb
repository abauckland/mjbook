class PaymentMailer < ActionMailer::Base

  def receipt(payment, document, current_user)
    
    @payment = payment
    @customer = Mjbook::Customer.joins(:project => [:invoice => [:ingroup => [:inline => :paymentitems]]]).where('mjbook_paymentitems.payment_id' => payment.id).first
    @user = current_user
    #add default email so that if customer doees not have an email address this action can complete and state of quote updated
    if @customer
      email_address = @customer.email
    else  
      email_address = current_user.email
    end
    
    email_subject = "Receipt" + "_" + @payment.ref + "_" + @payment.date.strftime("%d-%m-%y")
    file_name = current_user.company.name + "_" + @payment.ref + "_" + @payment.date.strftime("%d-%m-%y") + ".pdf"
    
    attachments[file_name] = document.render
       
    mail(to: email_address, subject: email_subject, cc: current_user.email ) do |format|
     # format.html { render 'another_template' }
      format.text
    end
  end
end