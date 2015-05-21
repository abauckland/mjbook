require_dependency "mjbook/application_controller"

module Mjbook
  class JournalsController < ApplicationController
    before_action :set_journal, only: [:show, :edit, :update, :destroy]

    # GET /journals
    def index
      if params[:paymentitems] == true
        @journals = policy_scope(Journal).where(:paymentitem_id => params[:paymentitem_ids])
      end

      if params[:expenditems] == true
        @journals = policy_scope(Journal).where(:expenditem_id => params[:expenditem_ids])
      end

      @journals = policy_scope(Journal)

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
      variation = @journal.adjustment - old_journal.adjustment

      if @journal.update(journal_params)

        #update adjustment for original year
        if @journal.paymentitem_id != nil
          current_period = accounting_period(@journal.paymentitem.payment.date)
        else
          current_period = accounting_period(@journal.expenditem.expend.date)
        end
        new_retained_amount = @journal.retained + variation
        current_period.update(:retained => new_retained_amount)

        #adjust year sum allocated to
        new_period = @journal.period_id
        new_retained_amount = new_period.retained - variation
        new_period.update(:retained => new_retained_amount)

        redirect_to @journal, notice: 'Journal was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /journals/1
    def destroy

      #take adjustment away from  original year
      if @journal.paymentitem_id != nil
        current_period = accounting_period(@journal.paymentitem.payment.date)
      else
        current_period = accounting_period(@journal.expenditem.expend.date)
      end
      new_retained_amount = current_period.retained + @journal.adjustment
      current_period.update(:retained => new_retained_amount)

      #adjust year sum allocated to
      new_period = @journal.period_id
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
  end
end
