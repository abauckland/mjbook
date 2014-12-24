require_dependency "mjbook/application_controller"

module Mjbook
  class SummariesController < ApplicationController

      def income_summary
        
        past_date = [[0,-30], [-31,-60], [-61,-90]]
        future_dates = [[1,30], [31,60], [61,90]]
        
        @inc_due = []
        @inc_pending = []
        
        past_dates.each_with_index do |dates, i|
          start_date = Time.now + dates[i][0]
          finish_date = Time.now + dates[i][1]
          invoices_due = policy_scope(Invoice).submitted.where("due_date >= ? AND due_date <= ?", start_date, finish_date).sum(:total)
          donations_due = policy_scope(Donation).submitted.where("due_date >= ? AND due_date <= ?", start_date, finish_date).sum(:total)
          miscs_due = policy_scope(Miscincome).submitted.where("due_date >= ? AND due_date <= ?", start_date, finish_date).sum(:total)
          @inc_due[i] = invoices_due + donations_due + miscs_due
        end
        
        future_dates.each_with_index do |dates, i|
          start_date = Time.now + dates[i][0]
          finish_date = Time.now + dates[i][1]
          invoices_pending = policy_scope(Invoice).submitted.where("due_date >= ? AND due_date <= ?", start_date, finish_date).sum(:total)
          donations_pending = policy_scope(Donation).submitted.where("due_date >= ? AND due_date <= ?", start_date, finish_date).sum(:total)
          miscs_pending = policy_scope(Miscincome).submitted.where("due_date >= ? AND due_date <= ?", start_date, finish_date).sum(:total)
          @inc_pending[i] = invoices_pending + donations_pending + miscs_pending
        end        
        
#var e1 = [@inc_due[0], @inc_due[1], @inc_due[2]];
#var e2 = [@inc_pending[0]];
#var e3 = [@inc_pending[1]];
#var e4 = [@inc_pending[2]];
      end
      
      def expenditure_summary
        
        past_date = [[0,-30], [-31,-60], [-61,-90]]
        future_dates = [[1,30], [31,60], [61,90]]
        
        @exp_due = []
        @exp_pending = []
        
        past_dates.each_with_index do |dates, i|
          start_date = Time.now + dates[i][0]
          finish_date = Time.now + dates[i][1]
          invoices_due = policy_scope(Expense).submitted.where("due_date >= ? AND due_date <= ?", start_date, finish_date).sum(:total)
          @exp_due[i] = expenses_due
        end
        
        future_dates.each_with_index do |dates, i|
          start_date = Time.now + dates[i][0]
          finish_date = Time.now + dates[i][1]
          expenses_pending = policy_scope(Expense).submitted.where("due_date >= ? AND due_date <= ?", start_date, finish_date).sum(:total)
          @exp_pending[i] = expenses_pending
        end        
        
#var e1 = [@exp_due[0], @exp_due[1], @exp_due[2]];
#var e2 = [@exp_pending[0]];
#var e3 = [@exp_pending[1]];
#var e4 = [@exp_pending[2]];
      end

      def transaction_summary
        #filter by date and account
        
        
        unless params[:date_from]
          date_from = 1.month.ago
        else
          date_from = params[:date_from]
        end
          
        unless params[:date_to]
          date_to = Time.now
        else
          date_to = params[:date_to]
        end
        
        payments = policy_scope(Payment).where("due_date >= ? AND due_date <= ?", date_from, date_to)
        payment_array = []
        payments.each do |payment|
          payment_hash = {}

          payment_hash[:date] = payment.date
          payment_hash[:your_ref] = payment.ref
          payment_hash[:account_name] = payment.companyaccount.name
          payment_hash[:type] = payment.inc_type
          payment_hash[:amount_in] = payment.total
          payment_hash[:amount_out] = nil
          payment_hash[:status] = payment.state
          payment_hash[:payment_id] = payment.id
          payment_hash[:expend_id] = nil

          payment_array << payment_hash
        end


        expends = policy_scope(Expend).where("due_date >= ? AND due_date <= ?", date_from, date_to)
        expend_array = []
        expends.each do |expend|
          payment_hash = {}

          expend_hash[:date] = expend.date
          expend_hash[:your_ref] = expend.ref
          expend_hash[:account_name] = expend.companyaccount.name
          expend_hash[:type] = expend.exp_type
          expend_hash[:amount_in] = nil
          expend_hash[:amount_out] = expend.tota
          expend_hash[:status] = expend.state
          expend_hash[:payment_id] = nil
          expend_hash[:expend_id] = expend.id

          expend_array << expend_hash
        end
        
        transactions = payment_array << expend_array
        @transactions_ordered = transations.sort_by{|transaction| transaction[:date]}

      end

  end
end
