class InvoiceMailer < ActionMailer::Base

  default from: current_user.company.email

  def invoice(invoice, document)
    
    @invoice = invoice
    @customer = Mjbook::Customer.joins(:project => :invoice).where('mjbook_invoices.payment_id' => invoice.id).first    
    if @customer
      email_address = @customer.email
    else  
      email_address = @current_user.email
    end
    
    email_subject = "Invoice" << @invoice.ref << @invoice.date
    file_name = current_user.company.name << "_" << @invoice.ref << "_" << @invoice.date << ".pdf"
    
    attachments['#{file_name}'] = document
   
    mail(to: email_address, subject: email_subject, cc: current_user.email ) do |format|
    #  format.html { render 'another_template' }
      format.text { render text: 'Render text' }
    end
  end
end