require_dependency "mjbook/application_controller"

module Mjbook
  class QuotesController < ApplicationController
        
    before_action :set_quote, only: [:show, :edit, :update, :destroy, :print]
    before_action :set_quoteterms, only: [:new, :edit]
        
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
              @quotes = Quote.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.company_id' => current_user.company_id)          
            else
              @quotes = Quote.joins(:project).where('date > ? AND mjbook_projects.company_id = ?', params[:date_from], current_user.company_id)  
            end  
          else  
            if params[:date_to] != ""
              @quotes = Quote.joins(:project).where('date < ? AND mjbook_projects.company_id = ?', params[:date_to], current_user.company_id)            
            else
              @quotes = Quote.joins(:project).where('mjbook_projects.company_id' => current_user.company_id)
            end     
          end
        end   
     
        if params[:commit] == 'pdf'          
          pdf_quote_index(@quotes, params[:customer_id], params[:date_from], params[:date_to])      
        end
            
     else
       @quotes = Quote.joins(:project).where('mjbook_projects.company_id' => current_user.company_id)       
     end          

     #selected parameters for filter form
     all_quotes = Quote.joins(:project).where('mjbook_projects.company_id' => current_user.company_id)       
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
      @projects = Project.where(:company_id => current_user.company_id)
    end

    # GET /quotes/1/edit
    def edit
    end

    # POST /quotes
    def create
      @quote = Quote.new(quote_params)

      if @quote.save
        redirect_to quotecontent_path(@quote.id), notice: 'Quote was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /quotes/1
    def update
      if @quote.update(quote_params)
        redirect_to @quote, notice: 'Quote was successfully updated.'
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
      @quote = Quote.where(:id => params[:id]).first 
      if @quote.update(:status => "accepted")        
        respond_to do |format|
          format.js   { render :accept, :layout => false }
        end  
      end      
    end 

    def reject
      #mark expense as rejected
      @quote = Quote.where(:id => params[:id]).first
      if @quote.update(:status => "rejected")
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
      
      def set_quoteterms
        @quoteterms = Quoteterm.where(:comany_id => current_user.company_id)        
      end

      # Only allow a trusted parameter "white list" through.
      def quote_params
        params.require(:quote).permit(:project_id, :ref, :title, :customer_ref, :date, :status, :price, :vat_due, :total)
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
