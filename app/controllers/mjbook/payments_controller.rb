require_dependency "mjbook/application_controller"

module Mjbook
  class PaymentsController < ApplicationController
    before_action :set_payment, only: [:show, :edit, :update, :destroy]

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
                @payments = Payment.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.company_id' => current_user.company_id)          
              else
                @payments = Payment.joins(:project).where('date > ? AND mjbook_projects.company_id = ?', params[:date_from], current_user.company_id)  
              end  
            else  
              if params[:date_to] != ""
                @payments = Payment.joins(:project).where('date < ? AND mjbook_projects.company_id = ?', params[:date_to], current_user.company_id)            
              else
                @payments = Payment.joins(:project).where('mjbook_projects.company_id' => current_user.company_id)
              end     
            end
          end   
       
          if params[:commit] == 'pdf'          
            pdf_payment_index(payments, params[:customer_id], params[:date_from], params[:date_to])      
          end
              
       else
         @payments = Payment.joins(:project).where('mjbook_projects.company_id' => current_user.company_id)       
       end          
  
       #selected parameters for filter form
       all_invoices = Invoice.joins(:project).where('mjbook_projects.company_id' => current_user.company_id)       
       @customers = Customer.joins(:projects => :quotes).where('mjbook_quotes.id' => all_invoices.ids)
       @customer = params[:customer_id]
       @date_from = params[:date_from]
       @date_to = params[:date_to]
      
    end

    # GET /payments/1
    def show
    end

    # GET /payments/new
    def new
      @payment = Payment.new
    end

    # GET /payments/1/edit
    def edit
    end

    # POST /payments
    def create
      @payment = Payment.new(payment_params)

      if @payment.save
        redirect_to @payment, notice: 'Payment was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /payments/1
    def update
      if @payment.update(payment_params)
        redirect_to @payment, notice: 'Payment was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /payments/1
    def destroy
      @payment.destroy
      redirect_to payments_url, notice: 'Payment was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_payment
        @payment = Payment.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def payment_params
        params.require(:payment).permit(:user_id, :invoice_id, :paymethod_id, :companyaccount_id, :price, :vat, :total, :date, :note)
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
  end
end
