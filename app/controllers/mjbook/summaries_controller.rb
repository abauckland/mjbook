require_dependency "mjbook/application_controller"

module Mjbook
  class SummariesController < ApplicationController

      def index

      if params[:period_name]
        if params[:period_name] != ""
          @period = policy_scope(Period).where(:name => params[:period_name]).first
        else
          #get current period
          @period = policy_scope(Period).where("year_start >= ? AND year_start <= ?", 1.year.from_now(Time.now),Time.now).first
        end
      end

      date_from = @period.year_start
      date_in_year = 1.year.from_now(@period.year_start)
      date_to = 1.day.ago(date_in_year)


      #INCOME SUMMARY
        @income_summary = policy_scope(Payment).where("date >= ? AND date <= ?", date_from, date_to
                                              ).where.not(:inc_type => "transfer"
                                              ).paid.pluck(:total).sum

      #EXPEND SUMMARY
        @expend_summary = policy_scope(Expend).where("date >= ? AND date <= ?", date_from, date_to
                                             ).where.not(:exp_type => "transfer"
                                             ).paid.pluck(:total).sum

      #ASSETS - CASH
        @assets_cash = 0
        @company_accounts = policy_scope(Companyaccount)
        @company_accounts.each do |account|
          amount = policy_scope(Summary).where("date <= ? AND companyaccount_id = ?", date_to, account.id).order(:date).last
          if amount
            @assets_cash = @assets_cash + amount.account_balance
          end
        end

      #ACCOUNTS: RECEIVABLE
        #no payment items
        invoices = policy_scope(Invoice).where("date >= ? AND date <= ?", date_from, date_to
                                       ).submitted.pluck(:total).sum
        
        #part paid items
#date range?
        array_inlines_paid = Paymentitem.joins(:inline => [:ingroup => [:invoice => :project]]
                                       ).where("mjbook_invoices.state" => :partpaid, "mjbook_projects.company_id" => current_user.company_id
                                       ).pluck(:inline_id)

#date range?
        part_paid = Inline.joins(:ingroup => [:invoice => :project]
                         ).where("mjbook_invoices.state" => :partpaid, "mjbook_projects.company_id" => current_user.company_id
                         ).where.not(:id => array_inlines_paid
                         ).pluck(:total).sum
        
        #miscincome
        miscincome = policy_scope(Miscincome).where("date >= ? AND date <= ?", date_from, date_to
                                            ).draft.pluck(:total).sum

        @receivable_summary = invoices + miscincome + part_paid

      #ACCOUNTS: PAYABLE
        #  @payable_summary = policy_scope(Expense).where("date >= ? AND date <= ?", date_from, date_to
        #                                         ).accepted.pluck(:total).sum

      #OPENING BALANCE
        #opening equity at beginning of the year
        #@period

      #SUMMARY BALANCE
        @debit_total = 0#@income_summary + @receivable_summary + @assets_cash
        @credit_total = 0#@expend_summary + @payable_summary
        
      #list of periods for select filter
      @periods = policy_scope(Period)

      end


      def show

        #filter by date and account
        @account = Mjbook::Companyaccount.where(:id => params[:id]).first

        if params[:period_name]
          if params[:period_name] != ""
            @period = policy_scope(Period).where(:name => params[:period_name]).first
          else
            #get current period
            @period = policy_scope(Period).where("year_start >= ? AND year_start <= ?", 1.year.from_now(Time.now),Time.now).first
          end
        end

        date_from = @period.year_start
        date_in_year = 1.year.from_now(@period.year_start)
        date_to = 1.day.ago(date_in_year)

        @transactions = policy_scope(Summary).where("date >= ? AND date <= ?", date_from, date_to).where(:companyaccount_id => params[:id]).order(:date)

        #list of periods for select filter
        @periods = policy_scope(Period)

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
