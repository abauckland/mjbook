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
        add_to_payment_year_end("add", @companyaccount.balance, @companyaccount.date)
        if policy_scope(Companyaccount).count == 1
          redirect_to summaries_path, notice: 'Company account was successfully created.'
        else
          redirect_to companyaccounts_path, notice: 'Company account was successfully created.'
        end
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
        redirect_to companyaccounts_path, notice: 'Company account was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /companyaccounts/1
    def destroy
      authorize @companyaccount
      @companyaccount.destroy
      #correct opening balance from running total
      remove_from_payment_year_end(@companyaccount.balance, @companyaccount.date)
      delete_account_expend_record(@companyaccount)
      redirect_to companyaccounts_url, notice: 'Company account was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_companyaccount
        @companyaccount = Companyaccount.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def companyaccount_params
        params.require(:companyaccount).permit(:company_id, :name, :provider, :code, :ref, :balance, :date)
      end


      def add_account_expend_record(account)
        Mjbook::Summary.create(:date => account.date,
                               :company_id => current_user.company.id,
                               :companyaccount_id => account.id,
                               :account_balance => account.balance)
      end

      def update_account_expend_record(old_settings, companyaccount)

        #update records before account creation date
        #update records after account creation date
        account_transactions = policy_scope(Summary).where(:companyaccount_id => companyaccount.id)
        balance_variation = companyaccount.balance - old_settings.balance
        if !account_transactions.blank?
          account_transactions.each do |transaction|
            new_account_balance = transaction.account_balance + balance_variation
            transaction.update(:account_balance => new_account_balance)
          end
        end
      end


      def delete_account_expend_record(old_settings, companyaccount)

        #update records before account creation date
        #update records after account creation date
        account_transactions = policy_scope(Summary).where(:companyaccount_id => companyaccount.id)
        #check that there is only one transaction (account set up transaction) before deleting account
        if account_transactions.count == 1
          account_transactions.each do |transaction|
            transaction.destroy
          end
        end
      end


      def add_to_payment_year_end(action, amount, date)
        #on create, update or delete payment item
        #determine year record to update based on date of transaction
        accounting_period(date)

        if action == "add" || action == "change"
          @period.update(:retained => (@period.retained + amount))
        end

      end

      def remove_from_payment_year_end(amount, date)
        #determine year record to update based on date of transaction
        accounting_period(date)
        @period.update(:retained => (@period.retained - amount))
      end


  end
end
