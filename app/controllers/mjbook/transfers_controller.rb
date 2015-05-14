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

        #CHECK ACCOUNTING PERIOD
        #returns period
        accounting_period(transfer.date)

        account_to = Companyaccount.find(transfer.account_to)

        #ADD AMOUNT
        #if transfer date before account create date
        if transfer.date < account_to.date
          #get next transfer for account in date order
          from_date = 1.day.from_now(transfer.date)
          to_date = 1.day.ago(account_to.date)
          next_record = policy_scope(Summary).where(:companyaccount_id => account_to.id
                                            ).where(:date => [from_date..to_date]
                                            ).order(:date, :id).first
          #if exists
          if !next_record.blank?
            #new value =  next value - subtract payment value
            new_account_balance = next_record.account_balance - transfer.total
          else
            new_account_balance = account_to.balance - transfer.total
          end

          #update subsequent transfer records
          subtract_from_prior_transactions(transfer, account_to)

        #if payment date after account create date 
        else
          #get last payment before
          to_date = 1.day.ago(transfer.date)
          from_date = account_to.date
          previous_record = policy_scope(Summary).where(:companyaccount_id => account_to.id
                                                ).where(:date => [from_date..to_date]
                                                ).order(:date, :id).last

          if !previous_record.blank?
            new_account_balance = previous_record.account_balance + transfer.total
          else
            new_account_balance = account_to.balance + transfer.total
          end

          #update subsequent payment records
          add_to_subsequent_transactions(transfer, account_to)

        end

        Mjbook::Summary.create(:company_id => current_user.company_id,
                               :date => transfer.date,
                               :companyaccount_id => account_to.id,
                               :transfer_id => transfer.id,
                               :amount_in => transfer.total,
                               :account_balance => new_account_balance)


        #SUBTRACT AMOUNT
        account_from = Companyaccount.find(transfer.account_from)
        #if expend date before account create date
        if transfer.date < account_from.date
          #get next expend for account in date order
          from_date = 1.day.from_now(transfer.date)
          to_date = 1.day.ago(account_from.date)
          next_record = policy_scope(Summary).where(:companyaccount_id => account_from.id
                                            ).where(:date => [from_date..to_date]
                                            ).order(:date, :id).first
          #if exists
          if !next_record.blank?
            #new value =  next value - subtract transfer value
            new_account_balance = next_record.account_balance + transfer.total
          else
            new_account_balance = account_from.balance + transfer.total
          end

          #update records before current date
          add_to_prior_transactions(transfer, account_from)

        #if expend date after account create date 
        else
          #get last expend before
          to_date = 1.day.ago(transfer.date)
          from_date = account_from.date
          previous_record = policy_scope(Summary).where(:companyaccount_id => account_from.id
                                                ).where(:date => [from_date..to_date]
                                                ).order(:date, :id).last

          if !previous_record.blank?
            new_account_balance = previous_record.account_balance - transfer.total
          else
            new_account_balance = account_from.balance - transfer.total
          end

          #update subsequent expend records
          subtract_from_subsequent_transactions(transfer, account_from)

        end

        Mjbook::Summary.create(:company_id => current_user.company_id,
                               :date => transfer.date,
                               :companyaccount_id => account_from.id,
                               :transfer_id => transfer.id,
                               :amount_out => transfer.total,
                               :account_balance => new_account_balance)

      end


      def delete_account_transfer_record(transfer)

        #delete add record
        account_to = Companyaccount.find(transfer.account_to)
        account_from = Companyaccount.find(transfer.account_from)
        #if transfer date before account create date
        if transfer.date < account_to.date
          #update records before current date
          add_to_prior_transactions(transfer, account_to)
        else
          #update subsequent transfer records
          subtract_from_subsequent_transactions(transfer, account_to)
        end


        #delete subtract record
        #if transfer date before account create date
        if transfer.date < transfer.account_from.date
          #update records before current date
          subtract_from_prior_transactions(transfer, account_from)
        else
          #update subsequent transfer records
          add_to_subsequent_transactions(transfer, account_from)
        end


        account_record = Summary.where(:transfer_id => transfer.id)
        account_record.each do |record|
          record.destroy
        end

      end


      def add_to_prior_transactions(transfer, account)
          #find records to update
          prior_transactions = policy_scope(Summary).where(:companyaccount_id => account.id
                                                   ).where('date < ?', transfer.date)
          #update prior balances
          if !prior_transactions.blank?
            add_amount_to(prior_transactions, transfer.total)
          end
      end

      def add_to_subsequent_transactions(transfer, account)
          #find records to update
          subsequent_transactions = policy_scope(Summary).where(:companyaccount_id => account.id
                                                        ).where('date > ?', transfer.date)
          #update prior balances
          if !subsequent_transactions.blank?
            add_amount_to(subsequent_transactions, transfer.total)
          end
      end


      def subtract_from_prior_transactions(transfer, account)
          #find records to update
          prior_transactions = policy_scope(Summary).where(:companyaccount_id => account.id
                                                   ).where('date < ?', transfer.date)
          #update prior balances
          if !prior_transactions.blank?
            subtract_amount_from(prior_transactions, transfer.total)
          end
      end

      def subtract_from_subsequent_transactions(transfer, account)
          #find records to update
          subsequent_transactions = policy_scope(Summary).where(:companyaccount_id => account.id
                                                        ).where('date > ?', transfer.date)
          #update prior balances
          if !subsequent_transactions.blank?
            subtract_amount_from(subsequent_transactions, transfer.total)
          end
      end


  end
end
