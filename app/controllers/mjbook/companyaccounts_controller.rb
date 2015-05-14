require_dependency "mjbook/application_controller"

module Mjbook
  class CompanyaccountsController < ApplicationController
    before_action :set_companyaccount, only: [:show, :edit, :update, :destroy]

    # GET /companyaccounts
    def index
      @companyaccounts = policy_scope(Companyaccount)
      authorize @companyaccounts
    end

    # GET /companyaccounts/new
    def new
      @companyaccount = Companyaccount.new
      authorize @companyaccount
    end

    # GET /companyaccounts/1/edit
    def edit
      authorize @companyaccount
    end

    # POST /companyaccounts
    def create
      @companyaccount = Companyaccount.new(companyaccount_params)
      authorize @companyaccount
      if @companyaccount.save
        add_account_expend_record(@companyaccount)
        
        redirect_to companyaccounts_path, notice: 'Companyaccount was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /companyaccounts/1
    def update
      authorize @companyaccount
      old_settings = @companyaccount.dup
      if @companyaccount.update(companyaccount_params)
        update_account_expend_record(old_settings, @companyaccount)
        redirect_to companyaccounts_path, notice: 'Companyaccount was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /companyaccounts/1
    def destroy
      authorize @companyaccount
      @companyaccount.destroy
      redirect_to companyaccounts_url, notice: 'Companyaccount was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_companyaccount
        @companyaccount = Companyaccount.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def companyaccount_params
        params.require(:companyaccount).permit(:company_id, :name, :provider, :code, :ref, :balance)
      end
      
      
      def add_account_expend_record(account)
        Mjbook::Summary.create(:date => Time.now,
                               :companyaccount_id => account.id,
                               :account_balance => 0)
      end

      def update_account_expend_record(old_settings, companyaccount)
        #update subsequent
        account_transactions = policy_scope(Summary).where(:companyaccount_id => companyaccount.id)
        balance_variation = companyaccount.balance - old_settings.balance
        if !account_transactions.blank?
          account_transactions.each do |transaction|
            new_account_balance = transaction.account_balance + balance_variation
            transaction.update(:balance => new_account_balance)
          end
        end
      end
      
  end
end
