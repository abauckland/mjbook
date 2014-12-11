require_dependency "mjbook/application_controller"

module Mjbook
  class InvoicesController < ApplicationController
    before_action :set_invoice, only: [:show, :edit, :update, :destroy, :reject, :accept]
    before_action :set_invoices, only: [:new, :create]
    before_action :set_invoiceterms, only: [:new, :create, :edit, :update]
    before_action :set_projects, only: [:new, :create, :edit, :update]

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

      if params[:invoice_content] == 'clone'
        
       clone_invoice = Invoice.where(:id => params[:clone_invoice]).first

       new_invoice_hash = {
                          :project_id => params[:invoice][:project_id],
                          :ref => params[:invoice][:ref],
                          :customer_ref => params[:invoice][:customer_ref],
                          :date => params[:invoice][:date],
                          :invoicetype_id => clone_invoice.invoicetype_id,
                          :invoiceterm_id => clone_invoice.invoiceterm_id,
                          :price => clone_invoice.price,
                          :vat_due => clone_invoice.vat_due,
                          :total => clone_invoice.total
                          }
                                  
        @invoice = Invoice.new(new_invoice_hash)
        if @invoice.save
          
          create_invoice_content(@invoice, clone_invoice)
          
          redirect_to invoicecontent_path(:id => @invoice.id), notice: 'Invoice was successfully created.'
        else
          render :new
        end
      else     
        @invoice = Invoice.new(invoice_params)
        if @invoice.save
          redirect_to invoicecontent_path(:id => @invoice.id), notice: 'Invoice was successfully created.'
        else
          render :new
        end
      end
    end

    # PATCH/PUT /invoice/1
    def update
      if @invoice.update(invoice_params)
        redirect_to invoicecontent_path(:id => @invoice.id), notice: 'Invoice was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /invoice/1
    def destroy
      @invoice.destroy
      redirect_to invoice_url, notice: 'Invoice was successfully destroyed.'
    end


    def quote_new
      create_clone(params[:id])

      redirect_to invoices_path, notice: 'Invoice was successfully created from quote.'

    end

    def accept
      #mark expense ready for payment
      if @invoice.accept!       
        respond_to do |format|
          format.js   { render :accept, :layout => false }
        end  
      end      
    end 

    def reject
      #mark expense as rejected
      if @invoice.reject!
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

      def set_invoices
        @invoices = policy_scope(Invoice)
      end      
      
      def set_projects
        @projects = policy_scope(Project).order('ref')
      end
      
      def set_invoiceterms
        @invoiceterms = policy_scope(Invoiceterm)        
      end

      # Only allow a trusted parameter "white list" through.
      def invoice_params
        params.require(:invoice).permit(:project_id, :ref, :customer_ref, :price, :vat_due, :total, :state, :date, :invoiceterm_id, :invoicetype_id)
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

      def create_invoice_content(invoice_id, clone_invoice)        

        clone_group = Mjbook::Ingroup.where(:invoice_id => clone_invoice.id)
        clone_group.each do |group|
          ingroup = group.dup
          ingroup.invoice_id = invoice_id
          ingroup.save

          clone_line = Mjbook::Inline.where(:qgroup_id => group.id)
          clone_line.each do |line|
            inline = line.dup
            inline.ingroup_id = ingroup.id
            inline.save
          end
        end        
      end


      def create_clone(clone_id)
        
        quote = Mjbook::Quote.where(:id => clone_id).first
        dup_quote = quote.dup
        @invoice = Invoice.create(dup_quote.attributes)



        clone_qgroup = Mjbook::Qgroup.where(:quote_id => quote.id)
        clone_qgroup.each do |group|
          dup_group = group.dup
          @ingroup = Mjbook::Ingroup.new(dup_group)
          @ingroup.invoice_id = @invoice.id
          @ingroup.save

          clone_qline = Mjbook::Qline.where(:qgroup_id => group.id)
          clone_qline.each do |line|
            dup_line = line.dup
            inline = Mjbook::Inline.new(dup_line)
            inline.ingroup_id = @ingroup.id
            inline.save
          end
        end

        quote.invoice
        
      end

  end
end
