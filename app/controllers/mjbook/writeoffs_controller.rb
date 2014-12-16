require_dependency "mjbook/application_controller"

module Mjbook
  class WriteoffsController < ApplicationController
    before_action :set_writeoff, only: [:show, :destroy]

    # GET /writeoffs
    def index
    
      if params[:customer_id]
    
          if params[:customer_id] != ""
            if params[:date_from] != ""
              if params[:date_to] != ""
                @writeoffs = Writeoff.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.customer_id' => params[:customer_id])          
              else
                @writeoffs = Writeoff.joins(:project).where('date > ? AND mjbook_projects.customer_id =?', params[:date_from], params[:customer_id]) 
              end  
            else  
              if params[:date_to] != ""
                @writeoffs = Writeoff.joins(:project).where('date < ? AND mjbook_projects.customer_id = ?', params[:date_to], params[:customer_id])            
              end
            end   
          else
            if params[:date_from] != ""
              if params[:date_to] != ""
               # @writeoffs = Writeoff.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.company_id' => current_user.company_id)          
                @writeoffs = policy_scope(Writeoff).where(:date => params[:date_from]..params[:date_to])          
              else
                #@writeoffs = Writeoff.joins(:project).where('date > ? AND mjbook_projects.company_id = ?', params[:date_from], current_user.company_id)  
                @writeoffs = policy_scope(Writeoff).where('date > ?', params[:date_from])  
              end  
            else  
              if params[:date_to] != ""
                #@writeoffs = Writeoff.joins(:project).where('date < ? AND mjbook_projects.company_id = ?', params[:date_to], current_user.company_id)            
                @writeoffs = policy_scope(Writeoff).where('date < ?', params[:date_to])            
              else
                #@writeoffs = Writeoff.joins(:project).where('mjbook_projects.company_id' => current_user.company_id)
                @writeoffs = policy_scope(Writeoff) 
              end     
            end
          end   
       
          if params[:commit] == 'pdf'          
            pdf_writeoff_index(writeoffs, params[:customer_id], params[:date_from], params[:date_to])      
          end
              
       else
         @writeoffs = policy_scope(Writeoff)     
       end          
  
       #selected parameters for filter form
       all_invoices = policy_scope(Invoice)     
       @customers = Customer.joins(:projects => :quotes).where('mjbook_quotes.id' => all_invoices.ids)
       @customer = params[:customer_id]
       @date_from = params[:date_from]
       @date_to = params[:date_to]


      authorize @writeoffs 
    end

    # GET /writeoffs/1
    def show
    end

    # POST /writeoffs
    def create
      @writeoff = Writeoff.new(writeoff_params)

      if @writeoff.save
        redirect_to @writeoff, notice: 'Writeoff was successfully created.'
      else
        render :new
      end
    end

    # DELETE /writeoffs/1
    def destroy
      @writeoff.destroy
      redirect_to writeoffs_url, notice: 'Writeoff was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_writeoff
        @writeoff = Writeoff.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def writeoff_params
        params.require(:writeoff).permit(:company_id, :ref, :price, :vat, :total, :date, :notes)
      end
  end
end
