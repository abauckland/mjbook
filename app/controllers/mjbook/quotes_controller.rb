require_dependency "mjbook/application_controller"

module Mjbook
  class QuotesController < ApplicationController
        
    before_action :set_quote, only: [:show, :edit, :update, :destroy, :print, :reject, :accept, :email, :print]
    before_action :set_quotes, only: [:new, :create]
    before_action :set_quoteterms, only: [:new, :edit, :create, :update]
    before_action :set_projects, only: [:new, :edit, :create, :update]
        
    include PrintIndexes
    include PrintQuote

    # GET /quotes
    def index      
    if params[:customer_id]
  
        if params[:customer_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @quotes = Quote.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.customer_id' => params[:customer_id])          
            else
              @quotes = Quote.joins(:project).where('date > ? AND mjbook_projects.customer_id =?', params[:date_from], params[:customer_id]) 
            end  
          else  
            if params[:date_to] != ""
              @quotes = Quote.joins(:project).where('date < ? AND mjbook_projects.customer_id = ?', params[:date_to], params[:customer_id])                      
            end
          end   
        else
          if params[:date_from] != ""
            if params[:date_to] != ""
              #@quotes = Quote.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.company_id' => current_user.company_id)          
              @quotes = policy_scope(Quote).where(:date => params[:date_from]..params[:date_to])          

            else
              #@quotes = Quote.joins(:project).where('date > ? AND mjbook_projects.company_id = ?', params[:date_from], current_user.company_id)  
              @quotes = policy_scope(Quote).where('date > ?', params[:date_from])  

            end  
          else  
            if params[:date_to] != ""
              #@quotes = Quote.joins(:project).where('date < ? AND mjbook_projects.company_id = ?', params[:date_to], current_user.company_id)            
              @quotes = policy_scope(Quote).where('date < ?', params[:date_to])            
 
            else
              @quotes = policy_scope(Quote)
            end     
          end
        end   
     
        if params[:commit] == 'pdf'          
          pdf_quote_index(@quotes, params[:customer_id], params[:date_from], params[:date_to])      
        end
            
     else
       @quotes = policy_scope(Quote)     
     end          

     #selected parameters for filter form
     all_quotes = policy_scope(Quote)     
     @customers = Customer.joins(:projects => :quotes).where('mjbook_quotes.id' => all_quotes.ids)
     @customer = params[:customer_id]
     @date_from = params[:date_from]
     @date_to = params[:date_to]

    end

    # GET /quotes/1
    def show
    end

    # GET /quotes/new
    def new
      @quote = Quote.new
      @projects = policy_scope(Project)
    end

    # GET /quotes/1/edit
    def edit

    end

    # POST /quotes
    def create
      if params[:quote_content] == 'clone_quote'
        
       clone_quote = Quote.where(:id => params[:clone_quote]).first

       new_quote_hash = {
                          :project_id => params[:quote][:project_id],
                          :ref => params[:quote][:ref],
                          :title => params[:quote][:title],
                          :customer_ref => params[:quote][:customer_ref],
                          :date => params[:quote][:date],
                          :quoteterm_id => clone_quote.quoteterm_id,
                          :price => clone_quote.price,
                          :vat_due => clone_quote.vat_due,
                          :total => clone_quote.total
                          }
        @quote = Quote.new(new_quote_hash)
        if @quote.save          
          create_quote_content(@quote, clone_quote)
          redirect_to quotecontent_path(:id => @quote.id), notice: 'Quote was successfully created.'
        else
          render :new
        end
      end 

      if params[:quote_content] == 'blank'
        @quote = Quote.new(quote_params)
        if @quote.save
          qgroup = Mjbook::Qgroup.create(:quote_id => @quote.id)
          qline = Mjbook::Qline.create(:qgroup_id => qgroup.id, :ref => '1', :text => 'Invoice section title')
          redirect_to quotecontent_path(:id => @quote.id), notice: 'Quote was successfully created.'
        else
          render :new
        end
      end
    end

    # PATCH/PUT /quotes/1
    def update
      if @quote.update(quote_params)
        @quote.draft!
        redirect_to quotecontent_path(:id => @quote.id), notice: 'Quote was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /quotes/1
    def destroy
      @quote.destroy
      redirect_to quotes_url, notice: 'Quote was successfully destroyed.'
    end
    
    def accept
      #mark expense ready for payment
      if @quote.accept!       
        respond_to do |format|
          format.js   { render :accept, :layout => false }
        end  
      end      
    end 

    def reject
      #mark expense as rejected
      if @quote.reject!
        respond_to do |format|
          format.js   { render :reject, :layout => false }
        end 
      end    
    end
    
    def print

        print_quote_document(@quote)
        filename = "#{@quote.project.ref}.pdf"

        send_data @document.render, filename: filename, :type => "application/pdf"
    end

    def email
        print_quote_document(@quote)
        QuoteMailer.quote(@quote, @document, current_user).deliver

        if @quote.submit!
          respond_to do |format|
            format.js { render :email, :layout => false, notice: 'Quote has been emailed to the customer.'}
          end
        end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_quote
        @quote = Quote.find(params[:id])
      end

      def set_quotes
        @quotes = policy_scope(Quote).order('ref')
      end
      
      def set_projects
        @projects = policy_scope(Project).order('ref')
      end
      
      def set_quoteterms
        @quoteterms = policy_scope(Quoteterm)      
      end

      # Only allow a trusted parameter "white list" through.
      def quote_params
        params.require(:quote).permit(:project_id, :ref, :title, :customer_ref, :date, :state, :price, :vat_due, :total, :quoteterm_id)
      end
      
      def pdf_quote_index(quotes, customer_id, date_from, date_to)
         customer = Customer.where(:id => customer_id).first if customer_id

         if customer
           filter_group = customer.name
         else
           filter_group = "All Customers"
         end
         
         filename = "Quotes_#{ filter_group }_#{ date_from }_#{ date_to }.pdf"
                 
         document = Prawn::Document.new(
            :page_size => "A4",
            :page_layout => :landscape,
            :margin => [10.mm, 10.mm, 5.mm, 10.mm]
          ) do |pdf|
      
            table_indexes(quotes, 'quote', filter_group, date_from, date_to, filename, pdf)
      
          end

          send_data document.render, filename: filename, :type => "application/pdf"
      end  

      def print_quote_document(quote)  
        @document= Prawn::Document.new(
                                        :page_size => "A4",
                                        :margin => [5.mm, 10.mm, 5.mm, 10.mm],
                                       ) do |pdf|
                                        print_quote(quote, pdf)       
                                       end
      end

      def create_quote_content(quote, clone_quote)

        clone_group = Mjbook::Qgroup.where(:quote_id => clone_quote.id)
        clone_group.each do |qgroup|
          
          new_qgroup = qgroup.dup
          new_qgroup.save
          new_qgroup.update(:quote_id => quote.id)
          
          clone_line = Mjbook::Qline.where(:qgroup_id => qgroup.id)
          clone_line.each do |qline|
            new_qline = qline.dup
            new_qline.save
            new_qline.update(:qgroup_id => new_qgroup.id)           
          end
        end        
      end
      
  end
end
