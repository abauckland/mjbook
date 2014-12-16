class QuoteMailer < ActionMailer::Base

  default from: current_user.company.email

#  def quote_email(quote)
  def quote(quote, document)
    
    @customer = Mjbook::Customer.joins(:project => :quote).where('mjbook_quotes.payment_id' => quote.id).first
    @quote = quote
    #add default email so that if customer doees not have an email address this action can complete and state of quote updated
    if @customer
      email_address = @customer.email
    else  
      email_address = @current_user.email
    end
    
    email_subject = "Quote" << @quote.ref << @quote.date
    file_name = current_user.company.name << "_" << @quote.ref << "_" << @quote.date << ".pdf"

    
    attachments['#{file_name}'] = document
    
    mail(to: email_address, subject: email_subject, cc: current_user.email ) do |format|
    #  format.html { render 'another_template' }
      format.text { render text: 'Render text' }
    end
  end
end  