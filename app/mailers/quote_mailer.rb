class QuoteMailer < ActionMailer::Base

  def quote(quote, document, current_user)

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

    mail(to: email_address, subject: email_subject, cc: current_user.email) do |format|
    #  format.html { render 'another_template' }
      format.text# { render text: 'Render text' }
    end
  end
end

#in controller
#QuoteMailer.quote(@quote, @document, current_user).deliver
#


#  config.action_mailer.delivery_method = :smtp

#  config.action_mailer.smtp_settings = {
#    :tls => true,
#    :address => "secure.emailsrvr.com",
#    :port => 465,
##    :domain => "myhq.org.uk",
##    :user_name => "admin@myhq.org.uk",
##    :password => "bubble",
#    :authentication => :login
# }

#msg = MyMailer.some_message
#msg.delivery_method.settings.merge!(@user.mail_settings)
#msg.deliver

#msg = QuoteMailer.quote(@quote, @document, current_user)
#msg.smtp_settings.merge!(:domain => @company.domain, :user_name => @company.user_name, :password => @company.password)
