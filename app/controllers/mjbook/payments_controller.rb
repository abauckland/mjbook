require_dependency "mjbook/application_controller"

module Mjbook
  class PaymentsController < ApplicationController
    before_action :set_payment, only: [:show, :edit, :update, :destroy, :reconcile, :unreconcile, :email]
    before_action :set_accounts, only: [:new, :edit, :invoice_paid, :process_misc]
    before_action :set_paymethods, only: [:new, :edit, :invoice_paid, :process_misc]

    include PrintIndexes
    include PrintReceipt
    
    # GET /payments
    def index

      if params[:companyaccount_id]

          if params[:companyaccount_id] != ""
            if params[:date_from] != ""
              if params[:date_to] != ""
                @payments = policy_scope(Payment).where(:date => params[:date_from]..params[:date_to], :companyaccount_id => params[:companyaccount_id])
              else
                @payments = policy_scope(Payment).where('date > ? AND companyaccount_id =?', params[:date_from], params[:companyaccount_id])
              end
            else
              if params[:date_to] != ""
                @payments = policy_scope(Payment).where('date < ? AND companyaccount_id = ?', params[:date_to], params[:companyaccount_id])
              else
                @payments = policy_scope(Payment).where(:companyaccount_id => params[:companyaccount_id])
              end
            end
          else
            if params[:date_from] != ""
              if params[:date_to] != ""
                @payments = policy_scope(Payment).where(:date => params[:date_from]..params[:date_to])
              else
                @payments = policy_scope(Payment).where('date > ?', params[:date_from])
              end
            else
              if params[:date_to] != ""
                @payments = policy_scope(Payment).where('date < ?', params[:date_to])
              else
                @payments = policy_scope(Payment)
              end
            end
          end

       else
         @payments = policy_scope(Payment)
       end

       if params[:commit] == 'pdf'
         pdf_payment_index(@payments, params[:companyaccount_id], params[:date_from], params[:date_to])
       end

       if params[:commit] == 'csv'          
         csv_payment_index(@payments, params[:companyaccount_id])
       end


       @sum_price = @payments.pluck(:price).sum
       @sum_vat = @payments.pluck(:vat).sum
       @sum_total = @payments.pluck(:total).sum

       #selected parameters for filter form
       companyaccount_ids = policy_scope(Payment).pluck(:companyaccount_id).uniq
       @companyaccounts = Companyaccount.where(:id => companyaccount_ids)
       @companyaccount = params[:companyaccount_id]
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

    def process_misc
      @payment = Payment.new
      @miscincome = Mjbook::Miscincome.where(:id => params[:id]).first
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
        end

        add_account_payment_record(@payment)

        redirect_to payments_path, notice: 'Payment was successfully recorded.'
      else
        redirect_to new_paymentscope_path(:invoice_id => params[:invoice_id])
      end

    end


    # PATCH/PUT /payments/1
    def update
      authorize @payment
      old_amount = @payment.dup
      if @payment.update(payment_params)
        update_account_payment_record(@payment)
        new_ammount = old_amount.total - @expend.total

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

      if @payment.misc?
        #paymentitems are destroyed when payments is deleted
        item = Mjbook::Paymentitem.where(:payment_id => @payment.id).first
        miscincome = Mjbook::Miscincome.where(:id => item.miscincome_id).first
        miscincome.correct!
      end

      delete_account_payment_record(@payment)

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

        settings = Mjbook::Setting.where(:company_id => current_user.company_id).first

        msg = PaymentMailer.receipt(@payment, @document, current_user, settings)
        if !settings.blank?
          user_mail_setting = {:domain => settings.email_domain, :user_name => settings.email_username, :password => settings.email_password}
          msg.delivery_method.settings.merge!(user_mail_setting)
        end
        msg.deliver

        if @payment.confirm!
          respond_to do |format|
            format.js   { render :email, :layout => false }
          end
        end
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


      def pdf_payment_index(payments, companyaccount_id, date_from, date_to)
         account = Mjbook::Companyaccount.where(:id => companyaccount_id).first if companyaccount_id

         if account
           filter_group = account.name
         else
           filter_group = "All Accounts"
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

      def csv_payment_index(payments, companyaccount_id, date_from, date_to)
         account = Mjbook::Companyaccount.where(:id => companyaccount_id).first if companyaccount_id

         if account
           filter_group = account.name
         else
           filter_group = "All Accounts"
         end
         
         filename = "Payments_#{ filter_group }_#{ date_from }_#{ date_to }.csv"

         send_data payments.to_csv, filename: filename, :type => "text/csv"
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


      def add_account_payment_record(payment)

        accounting_period(payment.date)

        #if payment date before account create date
        if payment.date < payment.companyaccount.date
          #get next payment for account in date order
          from_date = payment.date
          to_date = 1.day.ago(payment.companyaccount.date)

          next_record = policy_scope(Summary).where(:companyaccount_id => payment.companyaccount_id
                                            ).where(:date => [from_date..to_date]
                                            ).order("date DESC").order("id DESC").first

          if !next_record.blank?
            if next_record.amount_out == nil
              new_account_balance = next_record.account_balance - next_record.amount_in
            else
              new_account_balance = next_record.account_balance + next_record.amount_out
            end
          else
            new_account_balance = payment.companyaccount.balance
          end

          #update subsequent payment records
          subtract_from_prior_transactions(payment)

        #if payment date after account create date 
        else
          #get last payment before
          to_date = payment.date
          from_date = payment.companyaccount.date
          previous_record = policy_scope(Summary).where(:companyaccount_id => payment.companyaccount_id
                                                ).where(:date => from_date..to_date
                                                ).order(:date, :id).last

          if !previous_record.blank?
            new_account_balance = previous_record.account_balance + payment.total
          else
            new_account_balance = payment.companyaccount.balance + payment.total
          end

          #update subsequent payment records
          add_to_subsequent_transactions(payment)

        end

        Mjbook::Summary.create(:company_id => current_user.company_id,
                               :date => payment.date,
                               :companyaccount_id => payment.companyaccount_id,
                               :payment_id => payment.id,
                               :amount_in => payment.total,
                               :account_balance => new_account_balance)

        #get applicable accounting period
        #update retained value in period - only if payment not between year start and date of account creation
        if payment.companyaccount.date >= @period.year_start && payment.companyaccount.date < 1.year.from_now(@period.year_start)
          unless payment.date >= @period.year_start && payment.date < payment.companyaccount.date
              @period.update(:retained => (@period.retained + amount))
          end
        else
          @period.update(:retained => (@period.retained + amount))
        end

      end


      def delete_account_payment_record(payment)

        accounting_period(payment.date)

        account_record = Summary.where(:payment_id => payment.id).first
        #if payment date before account create date
        if payment.date < payment.companyaccount.date
          #update records before current date
          add_to_prior_transactions(payment)
          add_to_subsequent_transactions_on_date(payment, account_record)
        else
          #update subsequent payment records
          subtract_from_subsequent_transactions(payment)
          subtract_from_subsequent_transactions_on_date(payment, account_record)
        end

        #update retained value in period

#        #update retained value in period - only if payment not between year start and date of account creation
        if payment.companyaccount.date >= @period.year_start && payment.companyaccount.date < 1.year.from_now(@period.year_start)
          unless payment.date >= @period.year_start && payment.date < payment.companyaccount.date
              @period.update(:retained => (@period.retained - amount))
          end
        else
          @period.update(:retained => (@period.retained - amount))
        end

        account_record.destroy

      end


      def subtract_from_prior_transactions(payment)
          #find records to update
          prior_transactions = policy_scope(Summary).where(:companyaccount_id => payment.companyaccount_id
                                                   ).where('date < ?', payment.date)
          #update prior balances
          if !prior_transactions.blank?
            subtract_amount_from(prior_transactions, payment.total)
          end
      end

      def add_to_subsequent_transactions(payment)
          #find records to update
          subsequent_transactions = policy_scope(Summary).where(:companyaccount_id => payment.companyaccount_id
                                                        ).where('date > ?', payment.date)
          #update prior balances
          if !subsequent_transactions.blank?
            add_amount_to(subsequent_transactions, payment.total)
          end
      end

      def add_to_prior_transactions(payment)
          #find records to update
          prior_transactions = policy_scope(Summary).where(:companyaccount_id => payment.companyaccount_id
                                                   ).where('date < ?', payment.date)
          #update prior balances
          if !prior_transactions.blank?
            add_amount_to(prior_transactions, payment.total)
          end
      end

      def subtract_from_subsequent_transactions(payment)
          #find records to update
          subsequent_transactions = policy_scope(Summary).where(:companyaccount_id => payment.companyaccount_id
                                                        ).where('date > ?', payment.date)
          #update prior balances
          if !subsequent_transactions.blank?
            subtract_amount_from(subsequent_transactions, payment.total)
          end
      end

      def add_to_subsequent_transactions_on_date(payment, account_record)
          prior_transactions = policy_scope(Summary).where(:companyaccount_id => payment.companyaccount_id
                                                   ).where(:date => payment.date
                                                   ).where('id > ?', account_record.id)
          if !prior_transactions.blank?
            add_amount_to(prior_transactions, payment.total)
          end
      end

      def subtract_from_subsequent_transactions_on_date(payment, account_record)
          #find records to update
          subsequent_transactions = policy_scope(Summary).where(:companyaccount_id => payment.companyaccount_id
                                                   ).where(:date => payment.date
                                                   ).where('id > ?', account_record.id)
          #update prior balances
          if !subsequent_transactions.blank?
            subtract_amount_from(subsequent_transactions, payment.total)
          end
      end

  end
end
