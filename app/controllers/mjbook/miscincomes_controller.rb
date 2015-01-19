require_dependency "mjbook/application_controller"

module Mjbook
  class MiscincomesController < ApplicationController
    before_action :set_miscincome, only: [:show, :edit, :update, :destroy, :accept, :email]
    before_action :set_projects, only: [:new, :create, :edit, :update]
    before_action :set_customers, only: [:index, :new, :edit]

    # GET /miscincomes
    def index

    if params[:supplier_id]

        if params[:supplier_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @miscincomes = policy_scope(Miscincome).where(:date => params[:date_from]..params[:date_to], :supplier_id => params[:supplier_id])
            else
              @miscincomes = policy_scope(Miscincome).where('date > ? AND supplier_id =?', params[:date_from], params[:supplier_id])
            end
          else
            if params[:date_to] != ""
              @miscincomes = policy_scope(Miscincome).where('date < ? AND supplier_id = ?', params[:date_to], params[:supplier_id])
            end
          end
        else
          if params[:date_from] != ""
            if params[:date_to] != ""
              @miscincomes = policy_scope(Miscincome).where(:date => params[:date_from]..params[:date_to])
            else
              @miscincomes = policy_scope(Miscincome).where('date > ?', params[:date_from])
            end
          else
            if params[:date_to] != ""
              @miscincomes = policy_scope(Miscincome).where('date < ?', params[:date_to])
            else
              @miscincomes = policy_scope(Miscincome)
            end
          end
        end

        if params[:commit] == 'pdf'          
          pdf_miscincome_index(@miscincomes, params[:supplier_id], params[:date_from], params[:date_to])      
        end

       else
         @miscincomes = policy_scope(Miscincome)
       end
  
       #selected parameters for filter form
       @customer = params[:customer_id]
       @date_from = params[:date_from]
       @date_to = params[:date_to]
    end

    # GET /miscincomes/1
    def show
    end

    # GET /miscincomes/new
    def new
      @miscincome = Miscincome.new
    end

    # GET /miscincomes/1/edit
    def edit
    end

    # POST /miscincomes
    def create
      @miscincome = Miscincome.new(miscincome_params)

      if @miscincome.save
        redirect_to miscincomes_path, notice: 'Misc income record was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /miscincomes/1
    def update
      if @miscincome.update(miscincome_params)
        redirect_to miscincomes_path, notice: 'Misc income record successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /miscincomes/1
    def destroy
      @miscincome.destroy
      redirect_to miscincomes_url, notice: 'Misc income record successfully deleted.'
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_miscincome
        @miscincome = Miscincome.find(params[:id])
      end

      def set_projects     
        @projects = policy_scope(Project)
      end

      def set_customers     
        @customers = policy_scope(Customer)
      end

      # Only allow a trusted parameter "white list" through.
      def miscincome_params
        params.require(:miscincome).permit(:company_id, :ref, :project_id, :date, :price, :vat, :total, :item, :customer_id, :customer_ref, :note, :state)
      end

      def pdf_miscincome_index(incomes, customer_id, date_from, date_to)
         customer = Customer.where(:id => customer_id).first if customer_id

         if supplier
           filter_group = customer.company_name
         else
           filter_group = "All Payees"
         end

         filename = "Misc_income_#{ filter_group }_#{ date_from }_#{ date_to }.pdf"

         document = Prawn::Document.new(
          :page_size => "A4",
          :page_layout => :landscape,
          :margin => [10.mm, 10.mm, 5.mm, 10.mm]
          ) do |pdf|      
            table_indexes(incomes, 'misc', filter_group, date_from, date_to, filename, pdf)
          end

          send_data document.render, filename: filename, :type => "application/pdf"        
      end

  end
end