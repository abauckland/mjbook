require_dependency "mjbook/application_controller"

module Mjbook
  class BalancesController < ApplicationController

      def index
        #redirect if the year_start date (and hence accounting period) have not been set
        #redirect if no company accounts have been set up for the company
        company_setting = Mjbook::Setting.where(:company_id => current_user.company_id).first
        account_exist = Mjbook::Companyaccount.where(:company_id => current_user.company_id).first
        #mileage settings
        unless company_setting && account_exist
          redirect_to setups_path
        else

          balance_period(params[:period_id])
          @summaries = policy_scope(Summary)
          authorize @summaries
          @periods = policy_scope(Period)
          account_summary(@summaries, @current_period, @date_from, @date_to)

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

      def balance_period(period_id)

        if period_id
          if period_id != ""
            @period = policy_scope(Period).where(:id => period_id).first
          else
            #get current period
            start_time = 1.year.ago(Time.now)
            end_time = Time.now
            @period = policy_scope(Period).where(:year_start => start_time..end_time).first
            @current_period = true
          end
        else
          #get current period
          start_time = 1.year.ago(Time.now)
          end_time = Time.now
          @period = policy_scope(Period).where(:year_start => start_time..end_time).first
          @current_period = true
        end

        @date_from = @period.year_start
        date_in_one_year = 1.year.from_now(@period.year_start)
        @date_to = 1.day.ago(date_in_one_year)

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
                                              ).pluck(:total).sum

      #EXPEND SUMMARY
        @expend_summary = policy_scope(Expend).where(:date => date_from..date_to
                                             ).where.not(:exp_type => "transfer"
                                             ).pluck(:total).sum

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
          @payable_business_summary = policy_scope(Expense).where(:date=> date_from..date_to
                                                          ).where(:exp_type => "business"
                                                          ).accepted.pluck(:total).sum

          @payable_employee_summary = policy_scope(Expense).where(:date=> date_from..date_to
                                                          ).where(:exp_type => "personal"
                                                          ).accepted.pluck(:total).sum

      #OPENING BALANCE
        #opening equity at beginning of the year
        #@period
        if current_period != true
          @retained_amount = @period.retained
        end


      #SUMMARY BALANCE
        @credit_total = @income_summary + @receivable_summary + @assets_cash
        @debit_total = 0#@expend_summary + @payable_summary


      end



  end
end