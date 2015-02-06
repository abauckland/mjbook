module Mjbook
class CreditnoteMailer < ActionMailer::Base
  
  def creditnote(creditnote, document, current_user, settings)
    
    @creditnote = creditnote
    @user = current_user

    @customer = Mjbook::Customer.joins(:projects => [:invoices => [:ingroup => [:inline => :creditnoteitems]]]).where('mjbook_creditnoteitems.payment_id' => creditnote.id).first
    #add default email so that if customer doees not have an email address this action can complete and state of quote updated
    if @customer
      email_address = @customer.email
    else  
      email_address = current_user.email
    end
    
    email_subject = "Credit Note" + "_" + @creditnote.ref + "_" + @creditnote.date.strftime("%d-%m-%y")
    file_name = current_user.company.name + "_" + @creditnote.ref + "_" + @creditnote.date.strftime("%d-%m-%y") + ".pdf"
    
    attachments[file_name] = document.render
    
    mail(to: email_address, subject: email_subject, cc: current_user.email, from: settings.email_username ) do |format|
   #   format.html { render 'another_template' }
      format.text
    end
  end
end
end