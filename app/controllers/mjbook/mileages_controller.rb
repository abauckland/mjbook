require_dependency "mjbook/application_controller"

module Mjbook
  class MileagesController < ApplicationController
    before_action :set_mileage, only: [:show, :edit, :update, :destroy]

    # GET /mileages
    def index
      @mileages = Mileage.all
    end

    # GET /mileages/1
    def show
    end

    # GET /mileages/new
    def new
      @mileage = Mileage.new
    end

    # GET /mileages/1/edit
    def edit
    end

    # POST /mileages
    def create
      @mileage = Mileage.new(mileage_params)

      if @mileage.save
        add_to_expenses(@mileage)

        redirect_to @mileage, notice: 'Mileage was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /mileages/1
    def update
      if @mileage.update(mileage_params)
        redirect_to @mileage, notice: 'Mileage was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /mileages/1
    def destroy
      @mileage.destroy
      redirect_to mileages_url, notice: 'Mileage was successfully destroyed.'
    end
    
    


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_mileage
        @mileage = Mileage.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def mileage_params
        params.require(:mileage).permit(:job_id, :mileagemode_id, :user_id, :hmrcexpcat_id, :start, :finish, :return, :distance, :date)
      end

      def add_to_expenses(mileage)
        
       distance = mileage.distance 
       mileage_rate = mileage.mode.rate
       amount = distance*mileage_rate 
        
       expense = Expense.new(:user_id => mileage.user_id,
                   :project_id => mileage.project_id,
                   :hmrcexpcat_id => 1, #id
                   :issue_date => Time.now,
                   :due_date => Time.now.utc.end_of_month,
                   :amount =>  amount,
                   :status => "submitted"
                   )
       expense.save 
                     
      end


  end
end
