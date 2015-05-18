require_dependency "mjbook/application_controller"

module Mjbook
  class JournalsController < ApplicationController
    before_action :set_journal, only: [:show, :edit, :update, :destroy]
    before_action :set_periods, only: [:new, :edit]

    # GET /journals
    def index
      @journals = policy_scope(Journal).all
    end

    # GET /journals/1
    def show
    end

    # GET /journals/new
    def new
      @journal = Journal.new
    end

    # GET /journals/1/edit
    def edit
    end

    # POST /journals
    def create
      @journal = Journal.new(journal_params)

      if @journal.save
        redirect_to @journal, notice: 'Journal was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /journals/1
    def update
      if @journal.update(journal_params)
        redirect_to @journal, notice: 'Journal was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /journals/1
    def destroy
      @journal.destroy
      redirect_to journals_url, notice: 'Journal was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_journal
        @journal = Journal.find(params[:id])
      end

      def set_periods
        @periods = policy_scope(Period)
      end

      # Only allow a trusted parameter "white list" through.
      def journal_params
        params.require(:journal).permit(:company_id, :paymentitem_id, :expenditem_id, :adjustment, :period_id, :note)
      end
  end
end
