module Mjbook
class InvoiceMailer < ActionMailer::Base

  def invoice(invoice, document, current_user, settings)
    
    @invoice = invoice
    @customer = Mjbook::Customer.joins(:projects => :invoices).where('mjbook_invoices.payment_id' => invoice.id).first    
    @user = current_user
        
    if @customer
      email_address = @customer.email
    else  
      email_address = current_user.email
    end
    
    email_subject = "Invoice" + "_" + @invoice.ref + "_" + @invoice.date.strftime("%d-%m-%y")
    file_name = current_user.company.name + "_" + @invoice.ref + "_" + @invoice.date.strftime("%d-%m-%y") + ".pdf"
    
    attachments[file_name] = document.render
   
    mail(to: email_address, subject: email_subject, cc: current_user.email, from: settings.email_username ) do |format|
    #  format.html { render 'another_template' }
      format.text
    end
  end
end
end