require_dependency "mjbook/application_controller"

module Mjbook
  class SummariesController < ApplicationController

    before_action :company_accounts, only: [:index, :show]
    before_action :company_account, only: [:show]
    before_action :set_summary, only: [:reconcile, :unreconcile]

      def index
        accounting_period(params[:period_id])

      end


      def show

        @summaries = policy_scope(Summary).where(:companyaccount_id => params[:companyaccount_id])

        if params[:date_from] !=""
          @summaries = @summaries.where('date >= ?', params[:date_from])
        end

        if params[:date_to] !=""
          @summaries = @summaries.where('date <= ?', params[:date_to])
        end

        @summaries = @summaries.order("date DESC").order("id DESC")

        @summary = @summaries.first
        authorize @summaries


#summaries_prior
#        summaries_prior = policy_scope(Summary).joins(:companyaccounts
#                                         ).where(:companyaccount_id => companyaccount.id
#                                         ).where('companyaccounts.date < ?', companyaccount.date)

#        if params[:date_from] !=""
#          summaries_prior = @summaries.where('date >= ?', params[:date_from])
#        end

#        if params[:date_to] !=""
#          summaries_prior = @summaries.where('date <= ?', params[:date_to])
#        end

#        summaries_prior = @summaries.order("date DESC").order("id DESC")

#summaries_subsequent
#        summaries_subsequent = policy_scope(Summary).joins(:companyaccounts
#                                         ).where(:companyaccount_id => companyaccount.id
#                                         ).where('companyaccounts.date >= ?', companyaccount.date)

#        if params[:date_from] !=""
#          summaries_subsequent = @summaries.where('date >= ?', params[:date_from])
#        end

#        if params[:date_to] !=""
#          summaries_subsequent = @summaries.where('date <= ?', params[:date_to])
#        end

#        summaries_subsequent = @summaries.order("date DESC").order("id ASC")

#        @summaries = [summaries_prior, summaries_subsequent]

        if params[:commit] == 'pdf'
          pdf_account_summary(@summaries, params[:companyaccount_id], params[:date_from], params[:date_to])
        end

        if params[:commit] == 'csv'
          csv_account_summary(@summaries, params[:companyaccount_id], params[:date_from], params[:date_to])
        end

      end


      def reconcile

        authorize @summary
        if @summary.reconcile!
          
          if @summary.payment_id?
            @summary.payment.reconcile!
          end

          if @summary.expend_id?
            @summary.expend.reconcile!
          end

#tranfers?

          respond_to do |format|
            format.js   { render :reconcile, :layout => false }
          end
        end
      end

      def unreconcile

        authorize @summary
        if @summary.unreconcile!

          if @summary.payment_id?
            @summary.payment.unreconcile!
          end

          if @summary.expend_id?
            @summary.expend.unreconcile!
          end

#transfers?

          respond_to do |format|
            format.js   { render :unreconcile, :layout => false }
          end
        end
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

      def company_account
        @company_account = policy_scope(Companyaccount).where(:id => params[:companyaccount_id]).first
      end

      def company_accounts
        @company_accounts = policy_scope(Companyaccount)
      end


      def accounting_period(period_id)

        if period_id
          if period_id != ""
            @period = Period.find(period_id)
          else
            #get current period
            start_time = 1.year.ago(Time.now)
            end_time = Time.now
            @period = policy_scope(Period).where(:year_start => start_time..end_time).first
            @current_period = true
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
        @income_summary = policy_scope(Payment).where(:date => date_from..date_to
                                              ).where.not(:inc_type => "transfer"
                                              ).paid.pluck(:total).sum

      #EXPEND SUMMARY
        @expend_summary = policy_scope(Expend).where(:date => date_from..date_to
                                             ).where.not(:exp_type => "transfer"
                                             ).paid.pluck(:total).sum

      #ACCOUNTS: RECEIVABLE
        #no payment items
        invoices = policy_scope(Invoice).where(:date => date_from..date_to
                                       ).submitted.pluck(:total).sum

        #part paid items
        array_inlines_paid = Paymentitem.joins(:inline => [:ingroup => [:invoice => :project]]
                                       ).where("mjbook_invoices.state" => :partpaid, "mjbook_projects.company_id" => current_user.company_id
                                       ).pluck(:inline_id)

        part_paid = Inline.joins(:ingroup => [:invoice => :project]
                         ).where("mjbook_invoices.state" => :partpaid, "mjbook_projects.company_id" => current_user.company_id
                         ).where("mjbook_invoices.date" => date_from..date_to
                         ).where.not(:id => array_inlines_paid
                         ).pluck(:total).sum

        #miscincome
        miscincome = policy_scope(Miscincome).where(:date => date_from..date_to
                                            ).draft.pluck(:total).sum

        #creditnote
        creditnote = policy_scope(Creditnote).where(:date => date_from..date_to
                                            ).confirmed.pluck(:total).sum
        #writeoff
        writeoff = policy_scope(Writeoff).where(:date => date_from..date_to
                                        ).pluck(:total).sum
                                            
        @receivable_summary = invoices + miscincome + part_paid - creditnote - writeoff

      #ACCOUNTS: PAYABLE
        #  @payable_business_summary = policy_scope(Expense).where(:date=> date_from..date_to
        #                                                  ).where(:exp_type => "business"
        #                                                  ).accepted.pluck(:total).sum

        #  @payable_employee_summary = policy_scope(Expense).where(:date=> date_from..date_to
        #                                                  ).where(:exp_type => "personal"
        #                                                  ).accepted.pluck(:total).sum

      #OPENING BALANCE
        #opening equity at beginning of the year
        #@period
        if current_period != true
          @retained_amount = @period.retained
        end


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
