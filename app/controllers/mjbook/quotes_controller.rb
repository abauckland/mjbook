require_dependency "mjbook/application_controller"

module Mjbook
  class QuotesController < ApplicationController
        
    before_action :set_quote, only: [:show, :edit, :update, :destroy, :print, :reject, :accept]
    before_action :set_quoteterms, only: [:new, :edit]
    before_action :set_projects, only: [:new, :edit]
        
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
      @quote = Quote.new(quote_params)

      if @quote.save
        redirect_to quotecontent_path(:id => @quote.id), notice: 'Quote was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /quotes/1
    def update
      if @quote.update(quote_params)
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

       document = Prawn::Document.new(
          :page_size => "A4",
          :margin => [5.mm, 10.mm, 5.mm, 10.mm],
          :info => {:title => @quote.project.title}
        ) do |pdf|    

          print_quote(@quote, pdf)
       
        end         

        filename = "#{@quote.project.ref}.pdf"   

        send_data document.render, filename: filename, :type => "application/pdf"      
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_quote
        @quote = Quote.find(params[:id])
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
      
  end
end