require_dependency "mjbook/application_controller"

module Mjbook
  class JournalsController < ApplicationController
    before_action :set_journal, only: [:show, :edit, :update, :destroy]

    # GET /journals
    def index

      if params[:period_id]
        @period = Mjbook::Period.find(params[:period_id])
      else
        accounting_period(Time.now)
      end
  
      date_from = @period.year_start
      date_to = 1.year.from_now(@period.year_start)


      if params[:transaction_type] == 'Payments'
        @journals = Journal.joins(:paymentitem => :payment
                                ).where('mjbook_payments.date' => date_from..date_to
                                ).where(:company_id => current_user.company_id
                                ).where.not(:paymentitem_id => nil)
      elsif params[:transaction_type] == 'Expenditures'
        @journals = Journal.joins(:expenditem => :expend
                                ).where('mjbook_expends.date' => date_from..date_to
                                ).where(:company_id => current_user.company_id
                                ).where.not(:expenditem_id => nil)
      else
        payment_journal_ids = Journal.joins(:paymentitem => :payment
                                 ).where('mjbook_payments.date' => date_from..date_to
                                 ).where(:company_id => current_user.company_id
                                 ).ids
        expend_journal_ids = Journal.joins(:expenditem => :expend
                                ).where('mjbook_expends.date' => date_from..date_to
                                ).where(:company_id => current_user.company_id
                                ).ids
        journal_ids = payment_journal_ids + expend_journal_ids
        @journals = Journal.where(:id => journal_ids.sort)
      end

      if params[:commit] == 'pdf'
        pdf_journal_index(@journals, params[:transaction_type], @period)
      end

      if params[:commit] == 'csv'
        csv_journal_index(@journals, params[:transaction_type], @period)
      end


      @transaction_types = ['All','Payments', 'Expenditures']
      if params[:transaction_type]
            @selected_transaction_type = params[:transaction_type]
      else
            @selected_transaction_type = 'All'
      end

      @periods = policy_scope(Period)


    end

    # GET /journals/1
    def show
      if @journal.paymentitem_id != nil
        accounting_period(@journal.paymentitem.payment.date)
      end
    end

    # GET /journals/new
    def new
      @journal = Journal.new

      if params[:paymentitem_id]
        @paymentitem = Mjbook::Paymentitem.find(params[:paymentitem_id])
        payment = Mjbook::Payment.find(@paymentitem.payment_id)
        accounting_period(payment.date)
      end

      if params[:expenditem_id]
        @expenditem = Mjbook::Expenditem.find(params[:expenditem_id])
        accounting_period(@expenditem.expend.date)
      end

      @periods = policy_scope(Period).where.not(:id => @period.id)

    end

    # GET /journals/1/edit
    def edit
      @periods = policy_scope(Period).where.not()
    end

    # POST /journals
    def create
      @journal = Journal.new(journal_params)

      if @journal.save
        #adjust period retained amounts

        #take adjustment away from  original year
        if @journal.paymentitem_id != nil
          accounting_period(@journal.paymentitem.payment.date)
        else
          accounting_period(@journal.expenditem.expend.date)
        end
        new_retained_amount = @period.retained - @journal.adjustment
        @period.update(:retained => new_retained_amount)

        #adjust year sum allocated to
        new_period = Mjbook::Period.find(@journal.period_id)
        new_retained_amount = new_period.retained + @journal.adjustment
        new_period.update(:retained => new_retained_amount)

        redirect_to @journal, notice: 'Journal was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /journals/1
    def update

      old_journal = @journal.dup

      if @journal.update(journal_params)
        variation = @journal.adjustment - old_journal.adjustment

        #update adjustment for original year
        if @journal.paymentitem_id != nil
          current_period = accounting_period(@journal.paymentitem.payment.date)
        else
          current_period = accounting_period(@journal.expenditem.expend.date)
        end
        new_retained_amount = @period.retained + variation
        @period.update(:retained => new_retained_amount)

        #adjust year sum allocated to
        new_period = Mjbook::Period.find(@journal.period_id)
        new_retained_amount = new_period.retained - variation
        new_period.update(:retained => new_retained_amount)

        redirect_to @journal, notice: 'Journal was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /journals/1
    def destroy

      #add adjustment to original year
      if @journal.paymentitem_id != nil
        current_period = accounting_period(@journal.paymentitem.payment.date)
      else
        current_period = accounting_period(@journal.expenditem.expend.date)
      end
      new_retained_amount = @period.retained + @journal.adjustment
      @period.update(:retained => new_retained_amount)

      #take adjustment from year allocated to
      new_period = Mjbook::Period.find(@journal.period_id)
      new_retained_amount = new_period.retained - @journal.adjustment
      new_period.update(:retained => new_retained_amount)

      @journal.destroy
      redirect_to journals_url, notice: 'Journal was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_journal
        @journal = Journal.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def journal_params
        params.require(:journal).permit(:company_id, :paymentitem_id, :expenditem_id, :adjustment, :period_id, :note)
      end


      def pdf_journal_index(journals, transaction_type, period)

         filename = "Journal_entries_#{ transaction_type }_#{ period }.pdf"

         document = Prawn::Document.new(
          :page_size => "A4",
          :page_layout => :landscape,
          :margin => [10.mm, 10.mm, 5.mm, 10.mm]
          ) do |pdf|
            table_indexes(journals, 'journal', transaction_type, period.year_start, 1.year.from_now(period.year_start), filename, pdf)
          end

          send_data document.render, filename: filename, :type => "application/pdf"
      end

      def csv_journal_index(journals, transaction_type, period)
         filename = "Journal_entries_#{ transaction_type }_#{ period }.pdf"
         send_data expenses.to_csv, filename: filename, :type => "text/csv"
      end

  end
end
