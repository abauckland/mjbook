require_dependency "mjbook/application_controller"

module Mjbook
  class CreditnotesController < ApplicationController
    before_action :set_creditnote, only: [:show, :destroy, :email]

    include PrintIndexes
    include PrintCredit


    # GET /creditnotes
    def index

       if params[:date_from]
         if params[:date_from] != ""
           if params[:date_to] != ""
             @creditnotes = policy_scope(Creditnote).where(:date => params[:date_from]..params[:date_to])
           else
             @creditnotes = policy_scope(Creditnote).where('date > ?', params[:date_from])
           end
         else
           if params[:date_to] != ""
             @creditnotes = policy_scope(Creditnote).where('date < ?', params[:date_to])
           else
             @creditnotes = policy_scope(Creditnote) 
           end
         end
       else
         @creditnotes = policy_scope(Creditnote) 
       end

       if params[:commit] == 'pdf'
         pdf_creditnote_index(@creditnotes, params[:date_from], params[:date_to])
       end

       if params[:commit] == 'csv'
          csv_creditnote_index(@creditnotes, params[:date_from], params[:date_to])
       end

       @check_creditnote_exist = policy_scope(Creditnote).first

       @sum_price = @creditnotes.sum(:price)
       @sum_vat = @creditnotes.sum(:vat)
       @sum_total = @creditnotes.sum(:total)

       @date_from = params[:date_from]
       @date_to = params[:date_to]

      authorize @creditnotes
    end

    # GET /creditnotes/1
    def show
      authorize @creditnote
    end

    # POST /creditnotes
    def create
      @creditnote = Creditnote.new(creditnote_params)
      authorize @creditnote
      if @creditnote.save

        inlines = Mjbook::Inline.where(:id => params[:line_ids].to_a)
        invoice = Mjbook::Invoice.where(:id => params[:invoice_id]).first
                  
        inlines.each do |item|
          Mjbook::Creditnoteitem.create(:creditnote_id => @creditnote.id, :inline_id => item.id)
          item.pay!
        end

        #check if all the inlines for the invoice have been paid
        check_inlines = Mjbook::Inline.paid.join(:ingroup).where('mjbooks_invoice_id' => invoice.id)
        if check_inlines.blank?
          invoice.pay!
        else
          invoice.part_pay!
        end
        
        redirect_to creditnotes_path, notice: 'Creditnote was successfully created.'
      else
        redirect_to new_paymentscope_path(:invoice_id => params[:invoice_id])
      end
    end

    # DELETE /creditnotes/1
    def destroy
      authorize @creditnote
      @creditnote.destroy
      redirect_to creditnotes_url, notice: 'Creditnote was successfully deleted.'
    end

    def email
      #change state of payment to show receipt has been emailed?
        authorize @creditnote
        print_creditnote_document(@creditnote)

        settings = Mjbook::Setting.where(:company_id => current_user.company_id).first

        msg = CreditnoteMailer.creditnote(@creditnote, @document, current_user, settings)
        if !settings.blank?
          user_mail_setting = {:domain => settings.email_domain, :user_name => settings.email_username, :password => settings.email_password}
          msg.delivery_method.settings.merge!(user_mail_setting)
        end
        msg.deliver

        if @creditnote.confirm!
          respond_to do |format|
            format.js   { render :email, :layout => false }
          end 
        end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_creditnote
        @creditnote = Creditnote.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def creditnote_params
        params.require(:creditnote).permit(:company_id, :ref, :price, :vat, :total, :date, :notes, :state)
      end

      def pdf_creditnote_index(expenses, date_from, date_to)

         filter_group = "all"

         filename = "Creditnotes_#{ filter_group }_#{ date_from }_#{ date_to }.pdf"
                 
         document = Prawn::Document.new(
          :page_size => "A4",
          :page_layout => :landscape,
          :margin => [10.mm, 10.mm, 5.mm, 10.mm]
          ) do |pdf|      
            table_indexes(expenses, 'creditnote', filter_group, date_from, date_to, filename, pdf)      
          end

          send_data document.render, filename: filename, :type => "application/pdf"        
      end

      def csv_creditnote_index(creditnotes, date_from, date_to)

         filename = "Credit_Notes_#{ date_from }_#{ date_to }.pdf"

         send_data creditnotes.to_csv, filename: filename, :type => "text/csv"
      end


      def print_creditnote_document(creditnote)
       @document = Prawn::Document.new(
                                             :page_size => "A4",
                                              :margin => [5.mm, 10.mm, 5.mm, 10.mm],
                                              :info => {:title => creditnote.ref}
                                            ) do |pdf|
                                              print_credit(creditnote, pdf)
                                            end
      end

  end
end
