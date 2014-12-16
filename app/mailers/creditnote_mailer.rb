class CreditnoteMailer < ActionMailer::Base

  default from: current_user.company.email

  def creditnote(creditnote, document)
    
    @creditnote = creditnote
    @customer = Mjbook::Customer.joins(:project => [:invoice => [:ingroup => [:inline => :creditnoteitems]]]).where('mjbook_creditnoteitems.payment_id' => creditnote.id).first
    #add default email so that if customer doees not have an email address this action can complete and state of quote updated
    if @customer
      email_address = @customer.email
    else  
      email_address = @current_user.email
    end
    
    email_subject = "Credit Note" << @creditnote.ref << @creditnote.date
    file_name = current_user.company.name << "_" << @creditnote.ref << "_" << @creditnote.date << ".pdf"
    
    attachments['#{file_name}'] = document
    
    mail(to: email_address, subject: email_subject, cc: current_user.email ) do |format|
   #   format.html { render 'another_template' }
      format.text { render text: 'Render text' }
    end
  end
end