require_dependency "mjbook/application_controller"

module Mjbook
  class MiscexpensesController < ApplicationController
    before_action :set_miscexpend, only: [:show, :edit, :update, :destroy]

    # GET /miscexpends
    def index
      @miscexpends = Miscexpend.all
    end

    # GET /miscexpends/1
    def show
    end

    # GET /miscexpends/new
    def new
      @miscexpend = Miscexpend.new
    end

    # GET /miscexpends/1/edit
    def edit
    end

    # POST /miscexpends
    def create
      @miscexpend = Miscexpend.new(miscexpend_params)

      if @miscexpend.save
        redirect_to @miscexpend, notice: 'Miscexpend was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /miscexpends/1
    def update
      if @miscexpend.update(miscexpend_params)
        redirect_to @miscexpend, notice: 'Miscexpend was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /miscexpends/1
    def destroy
      @miscexpend.destroy
      redirect_to miscexpends_url, notice: 'Miscexpend was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_miscexpend
        @miscexpend = Miscexpend.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def miscexpend_params
        params.require(:miscexpend).permit(:company_id, :user_id, :exp_type, :ref, :project_id, :hmrcexpcat_id, :date, :due_date, :price, :vat, :total, :item, :provider_id, :provider_ref, :receipt, :note, :state)
      end
  end
end
