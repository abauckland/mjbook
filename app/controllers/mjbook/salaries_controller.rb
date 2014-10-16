require_dependency "mjbook/application_controller"

module Mjbook
  class SalariesController < ApplicationController
    before_action :set_salary, only: [:show, :edit, :update, :destroy]
    before_action :set_users, only: [:new, :edit]

    # GET /salaries
    def index
      @salaries = Salary.all
    end

    # GET /salaries/1
    def show
    end

    # GET /salaries/new
    def new
      @salary = Salary.new
    end

    # GET /salaries/1/edit
    def edit
    end

    # POST /salaries
    def create
      @salary = Salary.new(salary_params)

      if @salary.save
        redirect_to @salary, notice: 'Salary was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /salaries/1
    def update
      if @salary.update(salary_params)
        redirect_to @salary, notice: 'Salary was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /salaries/1
    def destroy
      @salary.destroy
      redirect_to salaries_url, notice: 'Salary was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_salary
        @salary = Salary.find(params[:id])
      end
      
      def set_users
        @users = User.where(:cpmpany_id => current_user.company_id).order('surname')
      end

      # Only allow a trusted parameter "white list" through.
      def salary_params
        params.require(:salary).permit(:company_id, :user_id, :paid, :date)
      end
  end
end
