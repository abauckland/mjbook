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
          account_summary(@summaries, @period, @current_period, @date_from, @date_to)

        end
      end

      def payable_business
        @expenses = policy_scope(Expense).business.where(:state => ['submitted','accepted'])
      end

      def payable_employee
        @expenses = policy_scope(Expense).personal.where(:state => ['submitted','accepted'])
      end

      def receivable
        @invoices = policy_scope(Invoice).where(:state => ['submitted'])
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

          #create new period if no records created since end of last period
          #loop until record for current date is created
          until !@period.blank?
            #get last period where year end is less than current time
            last_period = policy_scope(Period).where('year_start < ?', 1.year.ago(Time.now)).last
            last_period_year_end = 1.year.from_now(last_period.year_start)

            create_period(last_period_year_end)

            @period = policy_scope(Period).where(:year_start => start_time..end_time).first

          end
          @current_period = true

        end

        @date_from = @period.year_start
        date_in_one_year = 1.year.from_now(@period.year_start)
        @date_to = 1.day.ago(date_in_one_year)

      end


      def account_summary(summaries, period, current_period, date_from, date_to)

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
        income_totals = policy_scope(Payment).where(:date => date_from..date_to
                                              ).where.not(:inc_type => "transfer"
                                              ).pluck(:total)
        if !income_totals.blank?
          income = income_totals.sum
        else
          income = 0
        end

        #calculate adjustments from journal entries
        #find journal entries that adjust sums in selected year
        subtract_adjustments_totals = policy_scope(Journal).joins(:paymentitem => :payment
                            ).where.not(:paymentitem_id => nil
                            ).where('mjbook_payments.date' => date_from..date_to
                            ).pluck(:adjustment)
        if !subtract_adjustments_totals.blank?
          subtract_adjustments = subtract__adjustments_totals.sum
        else
          subtract_adjustments = 0
        end
        #subtract sums attributed from selected period

        #add sums attributed to selected period
        add_adjustments_totals = policy_scope(Journal).joins(:paymentitem => :payment
                            ).where.not(:paymentitem_id => nil
                            ).where(:period_id => period.id
                            ).pluck(:adjustment)
        if !add_adjustments_totals.blank?
          add_adjustments = add_adjustments_totals.sum
        else
          add_adjustments = 0
        end

        @income_summary = income - subtract_adjustments + add_adjustments


      #EXPEND SUMMARY
        expend_totals = policy_scope(Expend).where(:date => date_from..date_to
                                             ).where.not(:exp_type => "transfer"
                                             ).pluck(:total)
        #calculate adjustments from journal entries
        #subtract sums attributed to selected period
        #add sums attributed from selected period
        if !expend_totals.blank?
          @expend_summary = expend_totals.sum
        else
          @expend_summary = 0
        end


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

       @payable_summary = @payable_business_summary + @payable_employee_summary

      #OPENING BALANCE
        #opening equity at beginning of the year
        #@period
        if current_period != true
          @retained_amount = @period.retained
        end


      #SUMMARY BALANCE
        @credit_total = @income_summary + @receivable_summary + @assets_cash
        @debit_total = @expend_summary + @payable_summary


      end



  end
end
