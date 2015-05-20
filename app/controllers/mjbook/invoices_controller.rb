require_dependency "mjbook/application_controller"

module Mjbook
  class InvoicesController < ApplicationController
    before_action :set_invoice, only: [:show, :edit, :update, :destroy, :accept, :email, :print]
    before_action :set_invoices, only: [:new, :create]
    before_action :set_quotes, only: [:new, :create]
    before_action :set_invoiceterms, only: [:new, :create, :edit, :update]
    before_action :set_projects, only: [:new, :create, :edit, :update]

    include PrintIndexes
    include PrintInvoice

    # GET /invoice
    def index
    if params[:customer_id]

        if params[:customer_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @invoices = policy_scope(Invoice).joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.customer_id' => params[:customer_id])
            else
              @invoices = policy_scope(Invoice).joins(:project).where('date > ? AND mjbook_projects.customer_id =?', params[:date_from], params[:customer_id])
            end
          else
            if params[:date_to] != ""
              @invoices = policy_scope(Invoice).joins(:project).where('date < ? AND mjbook_projects.customer_id = ?', params[:date_to], params[:customer_id])
            else
              @invoices = policy_scope(Invoice).joins(:project).where('mjbook_projects.customer_id' =>params[:customer_id])
            end
          end
        else
          if params[:date_from] != ""
            if params[:date_to] != ""
              @invoices = policy_scope(Invoice).where(:date => params[:date_from]..params[:date_to])
            else
              @invoices = policy_scope(Invoice).where('date > ?', params[:date_from])
            end
          else
            if params[:date_to] != ""
              @invoices = policy_scope(Invoice).where('date < ?', params[:date_to])
            else
              @invoices = policy_scope(Invoice)
            end
          end
        end

        if params[:commit] == 'pdf'
          pdf_invoice_index(@invoices, params[:customer_id], params[:date_from], params[:date_to])
        end

        if params[:commit] == 'csv'
          csv_invoice_index(@invoices, params[:customer_id], params[:date_from], params[:date_to])
        end

     else
       @invoices = policy_scope(Invoice)
     end

     #selected parameters for filter form
     all_invoices = policy_scope(Invoice)
     @customers = Customer.joins(:projects => :invoices).where('mjbook_invoices.id' => all_invoices.ids).uniq
     @customer = params[:customer_id]
     @date_from = params[:date_from]
     @date_to = params[:date_to]
    end

    # GET /invoice/1
    def show
      authorize @invoice
    end

    # GET /invoice/new
    def new
      @invoice = Invoice.new
    end

    # GET /invoice/1/edit
    def edit
      authorize @invoice
    end

    # POST /invoice
    def create

      if params[:invoice_content] == 'clone_quote'
        
       clone_quote = Quote.where(:id => params[:clone_quote]).first

       new_invoice_hash = {
                          :project_id => clone_quote.project_id,
                          :ref => params[:invoice][:ref],
                          :customer_ref => params[:invoice][:customer_ref],
                          :date => params[:invoice][:date],
                          :invoicetype_id => params[:invoice][:invoicetype_id],
                          :invoiceterm_id => params[:invoice][:invoiceterm_id],
                          :price => clone_quote.price,
                          :vat_due => clone_quote.vat_due,
                          :total => clone_quote.total
                          }
        @invoice = Invoice.new(new_invoice_hash)
      authorize @invoice
        if @invoice.save

          create_quote_content(@invoice, clone_quote)

          redirect_to invoicecontent_path(:id => @invoice.id), notice: 'Invoice was successfully created.'
        else
          render :new
        end
      end

      if params[:invoice_content] == 'clone_invoice'

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
      end


      if params[:invoice_content] == 'blank'
        @invoice = Invoice.new(invoice_params)
        if @invoice.save
          ingroup = Mjbook::Ingroup.create(:invoice_id => @invoice.id, :ref => '1', :text => 'Invoice section title')
          inline = Mjbook::Inline.create(:ingroup_id => ingroup.id)
          redirect_to invoicecontent_path(:id => @invoice.id), notice: 'Invoice was successfully created.'
        else
          render :new
        end
      end
    end

    # PATCH/PUT /invoice/1
    def update
      authorize @invoice
      if @invoice.update(invoice_params)
        redirect_to invoicecontent_path(:id => @invoice.id), notice: 'Invoice was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /invoice/1
    def destroy
      authorize @invoice
      @invoice.destroy
      redirect_to invoices_path, notice: 'Invoice was successfully deleted.'
    end

    def print
      authorize @invoice
      print_invoice_document(@invoice)
      filename = "#{@invoice.project.ref}.pdf"

        send_data @document.render, filename: filename, :type => "application/pdf"      
    end

    def email
      authorize @invoice
      print_invoice_document(@invoice)

      settings = Mjbook::Setting.where(:company_id => current_user.company_id).first

      msg = InvoiceMailer.invoice(@invoice, @document, current_user, settings)
      if !settings.blank?
        user_mail_setting = {:domain => settings.email_domain, :user_name => settings.email_username, :password => settings.email_password}
        msg.delivery_method.settings.merge!(user_mail_setting)
      end
      msg.deliver

      if @invoice.submit!
        respond_to do |format|
          format.js   { render :email, :layout => false }
        end
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_invoice
        @invoice = Invoice.find(params[:id])
      end

      def set_quotes
        @quotes = policy_scope(Quote).accepted.order('ref')
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

      def csv_invoice_index(invoices, customer_id, date_from, date_to)
         customer = Customer.where(:id => customer_id).first if customer_id

         if customer
           filter_group = customer.name
         else
           filter_group = "All Customers"
         end

         filename = "Invoices_#{ filter_group }_#{ date_from }_#{ date_to }.csv"

         send_data invoices.to_csv, filename: filename, :type => "text/csv"
      end


      def print_invoice_document(invoice)
            @document = Prawn::Document.new(
                                            :page_size => "A4",
                                            :margin => [5.mm, 10.mm, 5.mm, 10.mm],
                                            :info => {:title => invoice.project.title}
                                            ) do |pdf|
                                              print_invoice(invoice, pdf)
                                            end
      end

      def create_invoice_content(invoice, clone_invoice)

        clone_group = Mjbook::Ingroup.where(:invoice_id => clone_invoice.id)
        clone_group.each do |ingroup| 
          new_ingroup = ingroup.dup
          new_ingroup.save
          new_ingroup.update(:invoice_id => invoice.id)
          
          clone_line = Mjbook::Inline.where(:ingroup_id => ingroup.id)
          clone_line.each do |inline|
            new_inline = inline.dup
            new_inline.save
            new_inline.update(:ingroup_id => new_ingroup.id)
          end
        end
      end

      def create_quote_content(invoice, clone_quote)
        
        clone_group = Mjbook::Qgroup.where(:quote_id => clone_quote.id)
        clone_group.each do |qgroup| 

          new_ingroup = Mjbook::Ingroup.create(
                                              :invoice_id => invoice.id,
                                              :ref => qgroup.ref,
                                              :text => qgroup.text,
                                              :price => qgroup.price,
                                              :vat_due => qgroup.vat_due,
                                              :total => qgroup.total,
                                              :group_order => qgroup.group_order
                                              )

          clone_line = Mjbook::Qline.where(:qgroup_id => qgroup.id)
          clone_line.each do |qline|

            new_inline = Mjbook::Inline.create(
                                              :ingroup_id => new_ingroup.id,
                                              :cat => qline.cat,
                                              :item => qline.item,
                                              :quantity => qline.quantity,
                                              :unit_id => qline.unit_id,
                                              :price => qline.price,
                                              :vat_id => qline.vat_id,
                                              :vat_due => qline.vat_due,
                                              :total => qline.total,
                                              :line_order => qline.line_order,
                                              :linetype => qline.linetype
                                              )
          end
        end
      end
      
  end
end
