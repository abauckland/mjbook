require_dependency "mjbook/application_controller"

module Mjbook
  class ExpendsController < ApplicationController
    before_action :set_expend, only: [:show, :edit, :update, :destroy]

    # GET /expends
    def index
    if params[:companyaccount_id]
  
        if params[:companyaccount_id] != ""
          if params[:date_from] != ""
            if params[:date_to] != ""
              @expends = Expend.where(:date => params[:date_from]..params[:date_to], :companyaccount_id => params[:companyaccount_id])
            else
              @expends = Expend.where('date > ? AND companyaccount_id =?', params[:date_from], params[:companyaccount_id])
            end  
          else  
            if params[:date_to] != ""
              @expends = Expend.where('date < ? AND companyaccount_id = ?', params[:date_to], params[:companyaccount_id])
            end
          end   
        else
          if params[:date_from] != ""
            if params[:date_to] != ""
              @expends = Expend.joins(:project).where(:date => params[:date_from]..params[:date_to], :company_id => current_user.company_id)
            else
              @expends = Expend.joins(:project).where('date > ? AND company_id = ?', params[:date_from], current_user.company_id)
            end  
          else  
            if params[:date_to] != ""
              @expends = Expend.joins(:project).where('date < ? AND company_id = ?', params[:date_to], current_user.company_id)
            else
              @expends = Expend.joins(:project).where(:company_id => current_user.company_id)
            end     
          end
        end   
     
        if params[:commit] == 'pdf'          
          pdf_expend_index(@expends, params[:companyaccount_id], params[:date_from], params[:date_to])      
        end
            
     else
       @expends = Expend.joins(:project).where(:company_id => current_user.company_id)
     end          

     #selected parameters for filter form     
     @companyaccounts = Mjbook::Companyaccount.where(:ompany_id => current_user.company_id)
     @companyaccount = params[:companyaccount_id]
     @date_from = params[:date_from]
     @date_to = params[:date_to]

    end

    # GET /expends/1
    def show
    end

    # GET /expends/new
    def new
      
      if params[:expense_id]
         @expense_id = params[:expense_id]
      end
        
      @expend = Expend.new
      @expenses = Mjbook::Expense.joins(:project).where('mjbook_projects.company_id' => current_user.company_id, :status => 'accepted').business
      
    end

    # GET /expends/new
    def new_personal
      
      if params[:user_id]
        @user_id = params[:user_id]
      end

      @users = Users.joins(:expenses).where(:company_id => current_user.company_id, 'mjbook_expenses.exp_type' => :personal)
      @expend = Expend.new

    end

    # GET /expends/new
    def edit_personal
      
      @expend = Expend.find(params[:id])
       
      #get list of all expenses for user
      @expenses = Mjbook::Expense.where(:user_id => @expend.user_id, :status => 'accepted').personal
 
      #calculate totals          
      #create new model         
      @expend = Expend.update(:price => @expenses.sum(:price),
                              :vat=> @expenses.sum(:vat),
                              :total=> @expenses.sum(:total))
                              
      @companyaccounts = Mjbook::Companyaccount.where(:company_id => current_user.company_id)

    end


    # GET /expends/1/edit
    def edit
      @companyaccounts = Mjbook::Companyaccount.where(:company_id => current_user.company_id)
    end

    # POST /expends
    def create
      @expend = Expend.new(expend_params)

      if @expend.save
        redirect_to edit_expend_path(@expend), notice: 'Expend was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /expends/1
    def update
      if @expend.update(expend_params)
        redirect_to expends_url, notice: 'Expend was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /expends/1
    def destroy
      @expend.destroy
      redirect_to expends_url, notice: 'Expend was successfully destroyed.'
    end
    
    def reconcile
      #update status setting
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_expend
        @expend = Expend.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def expend_params
        params.require(:expend).permit(:company_id, :user_id, :expense_id, :paymethod_id, :companyaccount_id, :expend_receipt, :date, :ref, :price, :vat, :total, :note)
      end

      def pdf_expend_index(expends, account_id, date_from, date_to)

         if account_id
           companyaccounts = Mjbook::Companyaccount.where(:id => account_id).first
           filter_group = companyaccounts.company_name
         else
           filter_group = "All Accounts"
         end
         
         filename = "Business_expenses_#{ filter_group }_#{ date_from }_#{ date_to }.pdf"
                 
         document = Prawn::Document.new(
          :page_size => "A4",
          :page_layout => :landscape,
          :margin => [10.mm, 10.mm, 5.mm, 10.mm]
          ) do |pdf|      
            table_indexes(expends, 'expend', filter_group, date_from, date_to, filename, pdf)      
          end

          send_data document.render, filename: filename, :type => "application/pdf"        
      end

  end
end
