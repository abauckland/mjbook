require_dependency "mjbook/application_controller"

module Mjbook
  class MileagesController < ApplicationController
    before_action :set_mileage, only: [:show, :edit, :update, :destroy]
    before_action :set_projects, only: [:new, :edit]
    before_action :set_mileagemodes, only: [:new, :edit]

    include PrintIndexes

    # GET /mileages
    def index
      @mileages = policy_scope(Mileage)
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

        redirect_to personals_path, notice: 'Mileage was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /mileages/1
    def update
      if @mileage.update(mileage_params)
        redirect_to personals_path, notice: 'Mileage was successfully updated.'
      else
        render :edit
      end
    end

    def print

      mileages = Mileage.where(:user_id => current_user.user_id)

      filename = "Mileage_expenses.pdf"
                 
      document = Prawn::Document.new(
        :page_size => "A4",
        :page_layout => :landscape,
        :margin => [10.mm, 10.mm, 5.mm, 10.mm]
      ) do |pdf|
        table_indexes(mileages, 'mileage', nil, nil, nil, filename, pdf)
      end

      send_data document.render, filename: filename, :type => "application/pdf"
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

      def set_projects
        @projects = policy_scope(Project)
      end

      def set_mileagemodes
        @mileagemodes = policy_scope(Mileagemode)
      end

      # Only allow a trusted parameter "white list" through.
      def mileage_params
        params.require(:mileage).permit(:project_id, :mileagemode_id, :user_id, :hmrcexpcat_id, :start, :finish, :return, :distance, :date)
      end

      def add_to_expenses(mileage)

    #   distance = mileage.distance
    #   mileage_rate = mileage.mileagemode.rate
     #  amount = distance*mileage_rate

        distance = mileage.distance.to_d
        mode = Mjbook::Mileagemode.where(:id => mileage.mileagemode_id, :company_id => current_user.company_id).first
        rate= mode.rate.to_d

        expense = Mjbook::Expense.new(
                    :company_id => current_user.company_id,
                    :user_id => current_user.id,
                    :mileage_id => mileage.id,
                    :project_id => mileage.project_id,
                    :hmrcexpcat_id => mileage.hmrcexpcat_id,
                    :date => Time.now,
                    :due_date => Time.now.utc.end_of_month,
                    :exp_type => "personal",
                    :price =>  distance*rate,
                    :vat =>  0,
                    :total => distance*rate,
                     )
        expense.save 

      end


  end
end
