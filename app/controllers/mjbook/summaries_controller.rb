require_dependency "mjbook/application_controller"

module Mjbook
  class SummariesController < ApplicationController

    before_action :set_summary, only: [:reconcile, :unreconcile]

      def index
        #redirect if the year_start date (and hence accounting period) have not been set
        #redirect if no company accounts have been set up for the company
        company_setting = Mjbook::Setting.where(:company_id => current_user.company_id).first
        account_exist = Mjbook::Companyaccount.where(:company_id => current_user.company_id).first
        unless company_setting  && account_exist
          redirect_to setups_path
        else
          accounting_period(params[:period_name])
          @summaries = policy_scope(Summary)
          authorize @summaries
          account_summary(@summaries, @current_period, @date_from, @date_to)
        end
      end

      def show

        @period = Period.where(:id => params[:period_id]).first

        start_time = @period.year_start
        end_time = 1.year.from_now(@period.year_start)
        @summaries = policy_scope(Summary).where(:date => start_time..end_time).where(:companyaccount_id => params[:id]).order(:date)
        @summary = @summaries.first
        authorize @summaries

        if params[:commit] == 'pdf'
          pdf_business_index(@summaries, params[:id], date_from, date_to)
        end

        if params[:commit] == 'csv'
          csv_business_index(@summaries, params[:id], date_from, date_to)
        end

        #list of periods for select filter
        @periods = policy_scope(Period)

      end

      def reconcile
        
        authorize @summary
        if @summary.reconcile!
          respond_to do |format|
            format.js   { render :reconcile, :layout => false }
          end
        end
      end
  
      def unreconcile
        
        authorize @summary
        if @summary.unreconcile!
          respond_to do |format|
            format.js   { render :unreconcile, :layout => false }
          end
        end
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


    def print

      accounting_period(params[:period_name])

      @summaries = policy_scope(Summary)
      @summary = @summaries.first
      authorize @summary

      account_summary(@summaries, date_from, date_to)

      print_period_summary(@period)

      filename = "#{@company}_#{period}.pdf"

      send_data @document.render, filename: filename, :type => "application/pdf"

    end


private

      # Use callbacks to share common setup or constraints between actions.
      def set_summary
        @summary = Summary.find(params[:id])
      end

      def accounting_period(period_name)

        if period_name
          if period_name != ""
            @period = policy_scope(Period).where(:name => period_name).first
          else
            #get current period
            start_time = 1.year.ago(Time.now)
            end_time = Time.now
            @period = policy_scope(Period).where(:year_start => start_time..end_time).first
          end
        else
          start_time = 1.year.ago(Time.now)
          end_time = Time.now
          @period = policy_scope(Period).where(:year_start => start_time..end_time).first
          @current_period = true
        end

        @date_from = @period.year_start
        date_in_year = 1.year.from_now(@period.year_start)
        @date_to = 1.day.ago(date_in_year)

      end


      def account_summary(summaries, current_period, date_from, date_to)

      #ASSETS - CASH
        @assets_cash = 0
        company_accounts = policy_scope(Companyaccount)
        company_accounts.each do |account|
          #filter by id to get last change to account
          amount = summaries.where("date <= ? AND companyaccount_id = ?", date_to, account.id).order(:date, :id).last
          if amount
            @assets_cash = @assets_cash + amount.account_balance
          end
        end


      #SUMMARY OF ACCOUNTS
      #show if select period equals current period
        if current_period == true
          @company_accounts = company_accounts
        end


      #INCOME SUMMARY
        @income_summary = policy_scope(Payment).where("date >= ? AND date <= ?", date_from, date_to
                                              ).where.not(:inc_type => "transfer"
                                              ).paid.pluck(:total).sum

      #EXPEND SUMMARY
        @expend_summary = policy_scope(Expend).where("date >= ? AND date <= ?", date_from, date_to
                                             ).where.not(:exp_type => "transfer"
                                             ).paid.pluck(:total).sum

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
        #  @payable_business_summary = policy_scope(Expense).where("date >= ? AND date <= ?", date_from, date_to
        #                                                  ).where(:exp_type => "business"
        #                                                  ).accepted.pluck(:total).sum

        #  @payable_employee_summary = policy_scope(Expense).where("date >= ? AND date <= ?", date_from, date_to
        #                                                  ).where(:exp_type => "personal"
        #                                                  ).accepted.pluck(:total).sum

      #OPENING BALANCE
        #opening equity at beginning of the year
        #@period

      #SUMMARY BALANCE
        @debit_total = @income_summary + @receivable_summary + @assets_cash
        @credit_total = 0#@expend_summary + @payable_summary

      #list of periods for select filter
        @periods = policy_scope(Period)

      end


      def pdf_account_summary(transactions, companyaccount_id, date_from, date_to)

         account = Companyaccount.where(:id => companyaccount_id)

         filename = "Summary_#{ account.name }_#{ date_from }_#{ date_to }.pdf"

         document = Prawn::Document.new(
          :page_size => "A4",
          :page_layout => :landscape,
          :margin => [10.mm, 10.mm, 5.mm, 10.mm]
          ) do |pdf|
            table_account_summary(transactions, "accounts", account.name, date_from, date_to, filename, pdf)

          end

          send_data document.render, filename: filename, :type => "application/pdf"
      end

      def csv_account_summary(transactions, companyaccount_id, date_from, date_to)
         account = Companyaccount.where(:id => companyaccount_id)

         filename = "Summary_#{ account.name }_#{ date_from }_#{ date_to }.csv"

         send_data transactions.to_csv, filename: filename, :type => "text/csv"
      end

  end
end
