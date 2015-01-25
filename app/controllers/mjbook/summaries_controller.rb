require_dependency "mjbook/application_controller"

module Mjbook
  class SummariesController < ApplicationController

      def index

        #filter by date and account
        unless params[:date_from]
          @date_from = 1.month.ago
        else
          @date_from = params[:date_from]
        end

        unless params[:date_to]
          @date_to = Time.now
        else
          @date_to = params[:date_to]
        end

        @transactions = policy_scope(Summary).where("date >= ? AND date <= ?", date_from, date_to).order(:date)

      end

      def charts

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

        past_date = [[0,-30], [-31,-60], [-61,-90]]
        future_dates = [[1,30], [31,60], [61,90]]

        @exp_due = []
        @exp_pending = []

        past_dates.each_with_index do |dates, i|
          start_date = Time.now + dates[i][0]
          finish_date = Time.now + dates[i][1]
          expenses_due = policy_scope(Expense).submitted.where("due_date >= ? AND due_date <= ?", start_date, finish_date).sum(:total)
          @exp_due[i] = expenses_due if expenses_due
        end

        future_dates.each_with_index do |dates, i|
          start_date = Time.now + dates[i][0]
          finish_date = Time.now + dates[i][1]
          expenses_pending = policy_scope(Expense).submitted.where("due_date >= ? AND due_date <= ?", start_date, finish_date).sum(:total)
          @exp_pending[i] = expenses_pending if expenses_pending
        end


        #filter by date and account

          date_from = 3.months.ago
          date_to = Time.now

        transactions = policy_scope(Summary).where("date >= ? AND date <= ?", date_from, date_to).order(:date)
        @transactions_array = transactions.select([:date, :balance]).map {|e| [e.date.strftime("%d/%m/%y"), pounds(e.balance)] } 
        
      end

  end
end
