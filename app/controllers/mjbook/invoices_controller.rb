require_dependency "mjbook/application_controller"

module Mjbook
  class InvoicesController < ApplicationController
    before_action :set_invoice, only: [:show, :edit, :update, :destroy, :reject, :accept]
    before_action :set_invoiceterms, only: [:new, :edit]

    include PrintIndexes
        
    # GET /invoice
    def index
    if params[:customer_id]
  
        if params[:customer_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @invoices = Invoice.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.customer_id' => params[:customer_id])          
            else
              @invoices = Invoice.joins(:project).where('date > ? AND mjbook_projects.customer_id =?', params[:date_from], params[:customer_id]) 
            end  
          else  
            if params[:date_to] != ""
              @invoices = Invoice.joins(:project).where('date < ? AND mjbook_projects.customer_id = ?', params[:date_to], params[:customer_id])            
            end
          end   
        else
          if params[:date_from] != ""
            if params[:date_to] != ""
              #@invoices = Invoice.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.company_id' => current_user.company_id)          
              @invoices = policy_scope(Invoice).where(:date => params[:date_from]..params[:date_to])
            else
              #@invoices = Invoice.joins(:project).where('date > ? AND mjbook_projects.company_id = ?', params[:date_from], current_user.company_id)  
              @invoices = policy_scope(Invoice).where('date > ?', params[:date_from])
            end  
          else  
            if params[:date_to] != ""
              #@invoices = Invoice.joins(:project).where('date < ? AND mjbook_projects.company_id = ?', params[:date_to], current_user.company_id)            
              @invoices = policy_scope(Invoice).where('date < ?', params[:date_to])
            else
              @invoices = policy_scope(Invoice) 
            end     
          end
        end   
     
        if params[:commit] == 'pdf'          
          pdf_invoice_index(invoices, params[:customer_id], params[:date_from], params[:date_to])      
        end
            
     else
       @invoices = policy_scope(Invoice)       
     end          

     #selected parameters for filter form
     all_invoices = policy_scope(Invoice)        
     @customers = Customer.joins(:projects => :quotes).where('mjbook_quotes.id' => all_invoices.ids)
     @customer = params[:customer_id]
     @date_from = params[:date_from]
     @date_to = params[:date_to]
    end

    # GET /invoice/1
    def show
    end

    # GET /invoice/new
    def new
      @invoice = Invoice.new
    end

    # GET /invoice/1/edit
    def edit
    end

    # POST /invoice
    def create
      @invoice = Invoice.new(invoice_params)

      if @invoice.save
        redirect_to @invoice, notice: 'Invoice was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /invoice/1
    def update
      if @invoice.update(invoice_params)
        redirect_to @invoice, notice: 'Invoice was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /invoice/1
    def destroy
      @invoice.destroy
      redirect_to invoice_url, notice: 'Invoice was successfully destroyed.'
    end

    def accept
      #mark expense ready for payment
      if @invoice.update(:status => "accepted")        
        respond_to do |format|
          format.js   { render :accept, :layout => false }
        end  
      end      
    end 

    def reject
      #mark expense as rejected
      if @invoice.update(:status => "rejected")
        respond_to do |format|
          format.js   { render :reject, :layout => false }
        end 
      end    
    end

    def print

       document = Prawn::Document.new(
        :page_size => "A4",
        :margin => [5.mm, 10.mm, 5.mm, 10.mm],
        :info => {:title => @invoice.project.title}
        ) do |pdf|    

          print_invoice(@invoice, pdf)
       
        end         

        filename = "#{@invoice.project.ref}.pdf"   

        send_data document.render, filename: filename, :type => "application/pdf"      
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_invoice
        @invoice = Invoice.find(params[:id])
      end

      def set_invoiceterms
        @invoiceterms = policy_scope(Invoiceterm)        
      end

      # Only allow a trusted parameter "white list" through.
      def invoice_params
        params.require(:invoice).permit(:project_id, :ref, :customer_ref, :price, :vat_due, :total, :status, :date, :invoiceterm_id, :invoicetype_id)
      end

      def pdf_invoice_index(invoices, customer_id, date_from, date_to)
         customer = Customer.where(:id => customer_id).first if customer_id

         if customer
           filter_group = customer.name
         else
           filter_group = "All Customers"
         end
         
         filename = "Invoices_#{ filter_group }_#{ date_from }_#{ date_to }.pdf"
                 
         document = Prawn::Document.new(
            :page_size => "A4",
            :page_layout => :landscape,
            :margin => [10.mm, 10.mm, 5.mm, 10.mm]
          ) do |pdf|
      
            table_indexes(invoices, 'invoice', filter_group, date_from, date_to, filename, pdf)
      
          end

          send_data document.render, filename: filename, :type => "application/pdf"
      end 

  end
end
