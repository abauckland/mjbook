require_dependency "mjbook/application_controller"

module Mjbook
  class TransfersController < ApplicationController
    before_action :set_transfer, only: [:show, :edit, :update, :destroy, :process_transfer, :rescind_transfer]
    before_action :set_companyaccounts, only: [:new, :edit]
    before_action :set_paymethods, only: [:new, :edit]
    
    # GET /transfers
    def index
      @transfers = policy_scope(Transfer)
      authorize @transfers
    end

    # GET /transfers/new
    def new
      @transfer = Transfer.new
    end

    # GET /transfers/1/edit
    def edit
      authorize @transfer
    end

    # POST /transfers
    def create
      @transfer = Transfer.new(transfer_params)
      authorize @transfer
      if @transfer.save
        redirect_to transfers_path, notice: 'Transfer was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /transfers/1
    def update
      authorize @transfer
      if @transfer.update(transfer_params)
        redirect_to transfers_path, notice: 'Transfer was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /transfers/1
    def destroy
      authorize @transfer
      #remove amount from account
      delete_account_transfer_record(@transfer)
      
      @transfer.destroy
      redirect_to transfers_url, notice: 'Transfer was successfully destroyed.'
    end

    def process_transfer
      authorize @transfer
      create_account_transfer_record(@transfer)

      @transfer.transfer!
      redirect_to transfers_url, notice: 'Transfer was successfully recorded.'

    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_transfer
        @transfer = Transfer.find(params[:id])
      end

      def set_companyaccounts
        @companyaccounts = policy_scope(Companyaccount) 
      end

      def set_paymethods
        @paymethods = Mjbook::Paymethod.all
      end


      # Only allow a trusted parameter "white list" through.
      def transfer_params
        params.require(:transfer).permit(:company_id, :user_id, :account_from_id, :account_to_id, :paymethod_id, :total, :date, :state)
      end



      def create_account_transfer_record(transfer)
        #add amount
        last_account_record = policy_scope(Summary).where('companyaccount_id = ? AND date <= ?', transfer.account_to_id, transfer.date).order(:date).last

        new_account_balance = last_account_record.account_balance + transfer.total

        Mjbook::Summary.create(:company_id => current_user.company_id,
                               :date => transfer.date,
                               :companyaccount_id => transfer.account_to_id,
                               :transfer_id => transfer.id,
                               :amount_in => transfer.total,
                               :account_balance => new_account_balance)

        account_transactions = policy_scope(Summary).subsequent_account_transactions(transfer.account_to_id, transfer.date)
        if !account_transactions.blank?
          account_transactions.each do |transaction|
            new_account_balance = transaction.account_balance + variation
            transaction.update(:account_balance => new_account_balance)
          end
        end


        #subtract_amount
        last_account_record = policy_scope(Summary).where('companyaccount_id = ? AND date <= ?', transfer.account_from_id, transfer.date).order(:date).last

        new_account_balance = last_account_record.account_balance - transfer.total

        Mjbook::Summary.create(:company_id => current_user.company_id,
                               :date => transfer.date,
                               :companyaccount_id => transfer.account_from_id,
                               :transfer_id => transfer.id,
                               :amount_out => transfer.total,
                               :account_balance => new_account_balance)

        account_transactions = policy_scope(Summary).subsequent_account_transactions(transfer.account_from_id, transfer.date)
        if !account_transactions.blank?
          account_transactions.each do |transaction|
            new_account_balance = transaction.account_balance - variation
            transaction.update(:account_balance => new_account_balance)
          end
        end
      end


      def delete_account_transfer_record(transfer)
        #delete add record
        variation = (0 - transfer.total)
        account_transactions = policy_scope(Summary).subsequent_account_transactions(transfer.account_to_id, transfer.date)
        if !account_transactions.blank?
          account_transactions.each do |transaction|
            new_account_balance = transaction.account_balance - variation
            transaction.update(:balance => new_account_balance)
          end
        end

        #delete subtract record
        variation = transfer.total
        account_transactions = policy_scope(Summary).subsequent_account_transactions(transfer.account_from_id, transfer.date)
        if !account_transactions.blank?
          account_transactions.each do |transaction|
            new_account_balance = transaction.account_balance + variation
            transaction.update(:balance => new_account_balance)
          end
        end

        account_record = Summary.where(:transfer_id => transfer.id)
        account_record.each do |record|
          record.destroy
        end

      end


  end
end
