require_dependency "mjbook/application_controller"

module Mjbook
  class PaymentsController < ApplicationController
    before_action :set_payment, only: [:show, :edit, :update, :destroy, :reconcile, :unreconcile, :email]
    before_action :set_accounts, only: [:new, :edit, :invoice_paid, :process_misc]
    before_action :set_paymethods, only: [:new, :edit, :invoice_paid. :process_misc]

    include PrintIndexes
    
    # GET /payments
    def index
    
      if params[:customer_id]
    
          if params[:customer_id] != ""
            if params[:date_from] != ""
              if params[:date_to] != ""
                @payments = Payment.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.customer_id' => params[:customer_id])          
              else
                @payments = Payment.joins(:project).where('date > ? AND mjbook_projects.customer_id =?', params[:date_from], params[:customer_id]) 
              end  
            else  
              if params[:date_to] != ""
                @payments = Payment.joins(:project).where('date < ? AND mjbook_projects.customer_id = ?', params[:date_to], params[:customer_id])            
              end
            end   
          else
            if params[:date_from] != ""
              if params[:date_to] != ""
               # @payments = Payment.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.company_id' => current_user.company_id)          
                @payments = policy_scope(Payment).where(:date => params[:date_from]..params[:date_to])          
              else
                #@payments = Payment.joins(:project).where('date > ? AND mjbook_projects.company_id = ?', params[:date_from], current_user.company_id)  
                @payments = policy_scope(Payment).where('date > ?', params[:date_from])  
              end  
            else  
              if params[:date_to] != ""
                #@payments = Payment.joins(:project).where('date < ? AND mjbook_projects.company_id = ?', params[:date_to], current_user.company_id)            
                @payments = policy_scope(Payment).where('date < ?', params[:date_to])            
              else
                #@payments = Payment.joins(:project).where('mjbook_projects.company_id' => current_user.company_id)
                @payments = policy_scope(Payment) 
              end     
            end
          end   
       
          if params[:commit] == 'pdf'          
            pdf_payment_index(payments, params[:customer_id], params[:date_from], params[:date_to])      
          end
              
       else
         @payments = policy_scope(Payment)     
       end          
  
       #selected parameters for filter form
       all_invoices = policy_scope(Invoice)     
       @customers = Customer.joins(:projects => :quotes).where('mjbook_quotes.id' => all_invoices.ids)
       @customer = params[:customer_id]
       @date_from = params[:date_from]
       @date_to = params[:date_to]


      authorize @payments      
    end

    # GET /payments/1
    def show
      authorize @payment
    end

    # GET /payments/new
    def new
      @payment = Payment.new
    end

    # GET /payments/1/edit
    def edit
      authorize @payment
    end

    # POST /payments
    def create

      @payment = Payment.new(payment_params)
      authorize @payment
      if @payment.save

        if @payment.invoice?
          inlines = Mjbook::Inline.where(:id => params[:line_ids].to_a)
          invoice = Mjbook::Invoice.where(:id => params[:invoice_id]).first

          inlines.each do |item|
            Mjbook::Paymentitem.create(:payment_id => @payment.id, :inline_id => item.id)
            item.pay!
          end

#          check_inlines = Mjbook::Inline.due.join(:ingroup).where(:invoice_id => params[:invoice_id], :total > 0)
# if check_lines.blank?
#check_empty_inlines = Mjbook::Inline.due.join(:ingroup).where(:invoice_id => params[:invoice_id], :total => nil)
# if check_empty_inlines
#check_empty_inlines.each do |item|
#  line.pay!
#end
#end 
          
          #check if all the inlines for the invoice have been paid          
          check_inlines = Mjbook::Inline.due.join(:ingroup).where(:invoice_id => params[:invoice_id])
          if check_inlines.blank?
            invoice.pay!
          else
            invoice.part_pay!
          end
        end

        if @payment.misc?
          miscincome = Mjbook::Miscincome.where(:id => params[:miscincome_id]).first
          Mjbook::Paymentitem.create(:payment_id => @payment.id, :miscincome_id => miscincome.id)
          miscincome.pay!
          @payment.confirm!
        end

        create_summary_record(@payment)
        add_summary_account_balance(@payment)
        add_summary_balance(@payment)

        redirect_to payments_path, notice: 'Payment was successfully recorded.'
      else
        redirect_to new_paymentscope_path(:invoice_id => params[:invoice_id])
      end


  #    if @payment.save
  #      redirect_to @payment, notice: 'Payment was successfully created.'
  #    else
  #      render :new
  #    end
    end

    # PATCH/PUT /payments/1
    def update
      authorize @payment
      if @payment.update(payment_params)
        redirect_to @payment, notice: 'Payment was successfully updated.'
      else
        render :edit
      end
    end


    # DELETE /payments/1
    def destroy
      authorize @payment

      if @payment.invoice?
        paymentitems = Mjbook::Paymentitem.where(:payment_id => @payment.id)
        paymentitems.each do |item|
          inline = Mjbook::Inline.where(:id => item.inline_id).first
          inline.rescind!
          #paymentitems are destroyed when payments is deleted
        end

        invoice = Mjbook::Invoice.joins(:ingroup => [:inline => :paymentitems]).where('mjbooks_paymentitems.payment_id' => @payment.id).first
        check_inlines = Mjbook::Inline.paid.join(:ingroup).where('mjbooks_invoice_id' => invoice.id)
        if check_inlines.blank?
          invoice.correct_payment!
        else
          invoice.correct_part_payment!
        end
      end

      if @payment.transfer?
        #paymentitems are destroyed when payments is deleted
        transfer = Mjbook::Transfer.where(:id => item.transfer_id).first
        transfer.correct_transfer!

        #if transfer is destroyed also need to destroy record of payment
        expend = Mjbook::Expend.joins(:expenditems).where('mjbook_expenditems.transfer_id' => transfer.id).first
        expend.destroy
        #expenditems are destroyed when payments is deleted
      end

      if @payment.misc?
        #paymentitems are destroyed when payments is deleted
        miscincome = Mjbook::Miscincome.where(:id => item.miscincome_id).first
        miscincome.correct_payment!
      end

      delete_summary_record(@payment)
      delete_summary_account_balance(@payment)
      delete_summary_balance(@payment)

      @payment.destroy
      redirect_to payments_url, notice: 'Payment was successfully deleted.'
    end


    def reconcile
      authorize @payment
      if @payment.reconcile!
        respond_to do |format|
          format.js   { render :reconcile, :layout => false }
        end
      end
    end

    def unreconcile
      authorize @payment
      if @payment.unreconcile!
        respond_to do |format|
          format.js   { render :unreconcile, :layout => false }
        end
      end
    end

    def email
        authorize @payment
        print_receipt_document(@payment)
        PaymentMailer.receipt(@payment, @document, current_user).deliver

        if @payment.confirm!
          respond_to do |format|
            format.js   { render :email, :layout => false }
          end
        end
    end

    def process_misc
      @payment = Payment.new
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_payment
        @payment = Payment.find(params[:id])
      end

      def set_accounts
        @companyaccounts = policy_scope(Companyaccount)
      end
      
      def set_paymethods
        @paymethods = Mjbook::Paymethod.all        
      end

      # Only allow a trusted parameter "white list" through.
      def payment_params
        params.require(:payment).permit(:ref, :company_id, :user_id, :paymethod_id, :companyaccount_id, :price, :vat, :total, :date, :inc_type, :notes, :state)
      end

      def pdf_quote_index(payments, customer_id, date_from, date_to)
         customer = Customer.where(:id => customer_id).first if customer_id

         if customer
           filter_group = customer.name
         else
           filter_group = "All Customers"
         end

         filename = "Payments_#{ filter_group }_#{ date_from }_#{ date_to }.pdf"

         document = Prawn::Document.new(
          :page_size => "A4",
          :page_layout => :landscape,
          :margin => [10.mm, 10.mm, 5.mm, 10.mm]
          ) do |pdf|

            table_indexes(payments, 'payment', filter_group, date_from, date_to, filename, pdf)

          end

          send_data document.render, filename: filename, :type => "application/pdf"
      end 

      def print_receipt_document(payment)  
              @document = Prawn::Document.new(
                                             :page_size => "A4",
                                              :margin => [5.mm, 10.mm, 5.mm, 10.mm],
                                              :info => {:title => payment.ref}
                                            ) do |pdf|
                                              print_receipt(payment, pdf)
                                            end
      end


      def create_summary_record(payment)
        last_transaction = policy_scope(Summary).subsequent_account_transactions(payment.companyaccount_id, payment.date).order('date').last
        
        new_balance = last_transaction.balance + payment.total
        new_account_balance = last_transaction.account_balance + payment.total
        
        Mjbook::Summaries.create(:date => payment.date,
                                  :company_id => payment.company_id,
                                  :payment_id => payment.id,
                                  :amount_out => payment.total,
                                  :balance => new_balance,
                                  :account_balance => new_account_balance)
      end

      def add_summary_account_balance(payment)
        account_transactions = policy_scope(Summary).subsequent_account_transactions(payment.companyaccount_id, payment.date)
        account_transactions.each do |account_transaction|
          new_account_balance = transaction.account_balance + payment.total
          account_transaction.update(:balance => new_account_balance)
        end
      end

      def add_summary_balance(payment)
        transactions = policy_scope(Summary).subsequent_transactions(payment.date)
        transactions.each do |transaction|
          new_balance = transaction.balance + payment.total
          transaction.update(:balance => new_balance)
        end
      end


      def delete_summary_record(payment)
        transaction = policy_scope(Summary).where(:payment_id => payment.id).first
        transaction.destroy
      end

      def delete_summary_account_balance(payment)
        account_transactions = policy_scope(Summary).subsequent_account_transactions(payment.companyaccount_id, payment.date)
        account_transactions.each do |account_transaction|
          new_account_balance = transaction.account_balance - payment.total
          account_transaction.update(:balance => new_account_balance)
        end
      end

      def delete_summary_balance(expend)
        transactions = policy_scope(Summary).subsequent_transactions(payment.date)
        transactions.each do |transaction|
          new_balance = transaction.balance - payment.total
          transaction.update(:balance => new_balance)
        end
      end

  end
end
