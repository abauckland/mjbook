require_dependency "mjbook/application_controller"

module Mjbook
  class MiscexpensesController < ApplicationController
    before_action :set_miscexpense, only: [:show, :edit, :update, :destroy, :accept, :reject]
    before_action :set_suppliers, only: [:index, :new, :edit]
    before_action :set_projects, only: [:new, :edit]
    before_action :set_hmrcexpcats, only: [:new, :edit]


    # GET /miscexpenses
    def index

    if params[:supplier_id]

        if params[:supplier_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @miscexpenses = policy_scope(Miscexpense).where(:date => params[:date_from]..params[:date_to], :supplier_id => params[:supplier_id])
            else
              @miscexpenses = policy_scope(Miscexpense).where('date > ? AND supplier_id =?', params[:date_from], params[:supplier_id])
            end  
          else  
            if params[:date_to] != ""
              @miscexpenses = policy_scope(Miscexpense).where('date < ? AND supplier_id = ?', params[:date_to], params[:supplier_id])
            else
              @miscexpenses = policy_scope(Miscexpense).where(:supplier_id => params[:supplier_id])
            end
          end
        else
          if params[:date_from] != ""
            if params[:date_to] != ""
              @miscexpenses = policy_scope(Miscexpense).where(:date => params[:date_from]..params[:date_to])
            else
              @miscexpenses = policy_scope(Miscexpense).where('date > ?', params[:date_from])
            end
          else
            if params[:date_to] != ""
              @miscexpenses = policy_scope(Miscexpense).where('date < ?', params[:date_to])
            else
              @miscexpenses = policy_scope(Miscexpense)
            end
          end
        end

        if params[:commit] == 'pdf'          
          pdf_miscexpense_index(@miscexpenses, params[:supplier_id], params[:date_from], params[:date_to])
        end

     else
       @miscexpenses = policy_scope(Miscexpense)
     end

     #selected parameters for filter form
     @suppliers = Supplier.joins(:expenses => :project).where('mjbook_projects.company_id' => current_user.company_id)
     @supplier = params[:supplier_id]
     @date_from = params[:date_from]
     @date_to = params[:date_to]

    end

    def index
      @miscexpenses = Miscexpense.all
    end

    # GET /miscexpenses/1
    def show
      authorize @miscexpense
    end

    # GET /miscexpenses/new
    def new
      @miscexpense = Miscexpense.new
    end

    # GET /miscexpenses/1/edit
    def edit
      authorize @miscexpense
    end

    # POST /miscexpenses
    def create
      @miscexpense = Miscexpense.new(miscexpense_params)
      authorize @miscexpense
      if @miscexpense.save
        redirect_to miscexpenses_path, notice: 'Misc expense was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /miscexpenses/1
    def update
      authorize @miscexpense
      if @miscexpense.update(miscexpense_params)
        redirect_to miscexpenses_path, notice: 'Misc expense was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /miscexpenses/1
    def destroy
      authorize @miscexpense
      @miscexpense.destroy
      redirect_to miscexpenses_path, notice: 'Misc expense was successfully destroyed.'
    end

    def accept
      authorize @miscexpense
      #mark expense ready for payment
      if @miscexpense.accept!     
        respond_to do |format|
          format.js   { render :accept, :layout => false }
        end
      end
    end

    def reject
      authorize @miscexpense
      #mark expense as rejected
      if @miscexpense.reject!
        respond_to do |format|
          format.js   { render :reject, :layout => false }
        end
      end
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_miscexpense
        @miscexpense = Miscexpense.find(params[:id])
      end

      def set_projects
        @projects = policy_scope(Project)
      end

      def set_suppliers
        @suppliers = policy_scope(Supplier)
      end

      def set_hmrcexpcats
        @hmrcexpcats = policy_scope(Hmrcexpcat)#.where(:hmrcgroup_id => 1) #pesonal
      end

      # Only allow a trusted parameter "white list" through.
      def miscexpense_params
        params.require(:miscexpense).permit(:company_id, :user_id, :ref, :project_id, :hmrcexpcat_id, :date, :due_date, :price, :vat, :total, :supplier_id, :supplier_ref, :receipt, :recurrence, :note, :state)
      end

      def pdf_miscexpense_index(expenses, supplier_id, date_from, date_to)
         supplier = Supplier.where(:id => supplier_id).first if supplier_id

         if supplier
           filter_group = supplier.company_name
         else
           filter_group = "All Suppliers"
         end

         filename = "Misc_expenses_#{ filter_group }_#{ date_from }_#{ date_to }.pdf"

         document = Prawn::Document.new(
          :page_size => "A4",
          :page_layout => :landscape,
          :margin => [10.mm, 10.mm, 5.mm, 10.mm]
          ) do |pdf|
            table_indexes(expenses, 'misc', filter_group, date_from, date_to, filename, pdf)
          end

          send_data document.render, filename: filename, :type => "application/pdf"
      end

  end
end
