module Mjbook
class QuoteMailer < ActionMailer::Base

  def quote(quote, document, current_user, settings)

    @customer = Mjbook::Customer.joins(:projects => :quotes).where('mjbook_quotes.id' => quote.id).first
    @quote = quote
    @user = current_user
    #add default email so that if customer doees not have an email address this action can complete and state of quote updated
    if @customer
      email_address = @customer.email
    else
      email_address = current_user.email
    end

    email_subject = "Quote" + "_" + @quote.ref + "_" + @quote.date.strftime("%d-%m-%y")
    file_name = current_user.company.name + "_" + @quote.ref + "_" + @quote.date.strftime("%d-%m-%y") + ".pdf"

    attachments[file_name] = document.render

    user_from_email = settings.email_username + '@' + settings.email_domain

    mail(to: email_address, subject: email_subject, cc: current_user.email, from: user_from_email) do |format|
    #  format.html { render 'another_template' }
      format.text# { render text: 'Render text' }
    end
  end
end
end
