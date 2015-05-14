require_dependency "mjbook/application_controller"

module Mjbook
  class SalariesController < ApplicationController
    before_action :set_salary, only: [:show, :edit, :update, :destroy, :accept, :reject]
    before_action :set_users, only: [:new, :edit, :update, :create]

    include PrintIndexes

    # GET /salaries
    def index

      if params[:user_id]

          if params[:user_id] != ""
            if params[:date_from] != ""
              if params[:date_to] != ""
                @salaries = Salary.where(:date => params[:date_from]..params[:date_to], :user_id => params[:user_id])
              else
                @salaries = Salary.where('date > ? AND user_id =?', params[:date_from], params[:user_id]) 
              end
            else
              if params[:date_to] != ""
                @salaries = Salary.where('date < ? AND user_id = ?', params[:date_to], params[:user_id])
              else  
                @salaries = Salary.where(:user_id => params[:user_id])
              end
            end
          else
            if params[:date_from] != ""
              if params[:date_to] != ""
                @salaries = policy_scope(Salary).where(:date => params[:date_from]..params[:date_to])
              else
                @salaries = policy_scope(Salary).where('date > ?', params[:date_from])
              end
            else
              if params[:date_to] != ""
                @salaries = policy_scope(Salary).where('date < ?', params[:date_to])
              else
                @salaries = policy_scope(Salary)
              end
            end
          end

          if params[:commit] == 'pdf'
            pdf_salary_index(@salaries, params[:user_id], params[:date_from], params[:date_to])
          end

          if params[:commit] == 'csv'
            csv_salary_index(@salaries, params[:user_id])
          end

       else
         @salaries = policy_scope(Salary)
       end

       @sum_total = @salaries.pluck(:total).sum

       #selected parameters for filter form
       user_id_array = policy_scope(Salary).pluck(:user_id).uniq    
       @users = User.where(:id => user_id_array) 
       @user = params[:user_id]
       @date_from = params[:date_from]
       @date_to = params[:date_to]

    end

    # GET /salaries/1
    def show
       authorize @salary
    end

    # GET /salaries/new
    def new
      @salary = Salary.new
    end

    # GET /salaries/1/edit
    def edit
       authorize @salary
    end

    # POST /salaries
    def create
      @salary = Salary.new(salary_params)
      authorize @salary
      if @salary.save
        redirect_to salaries_path, notice: 'Salary was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /salaries/1
    def update
      authorize @salary
      if @salary.update(salary_params)
        redirect_to salaries_path, notice: 'Salary was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /salaries/1
    def destroy
      authorize @salary
      @salary.destroy
      redirect_to salaries_path, notice: 'Salary was successfully destroyed.'
    end

    def accept
      authorize @salary
      #mark expense ready for payment
      if @salary.accept!       
        respond_to do |format|
          format.js   { render :accept, :layout => false }
        end
      end
    end

    def reject
      authorize @salary
      #mark expense as rejected
      if @salary.reject!
        respond_to do |format|
          format.js   { render :reject, :layout => false }
        end
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_salary
        @salary = Salary.find(params[:id])
      end

      def set_users
        @users = policy_scope(User)
      end

      # Only allow a trusted parameter "white list" through.
      def salary_params
        params.require(:salary).permit(:company_id, :user_id, :total, :date, :state)
      end


      def pdf_salary_index(salaries, user_id, date_from, date_to)
        filename(user_id)

        document = Prawn::Document.new(
          :page_size => "A4",
          :page_layout => :landscape,
          :margin => [10.mm, 10.mm, 5.mm, 10.mm]
        ) do |pdf|
          table_indexes(salaries, 'salary', nil, nil, nil, filename, pdf)
        end

        send_data document.render, filename: (filename+"pdf"), :type => "application/pdf"
      end

      def csv_salary_index(salaries, user_id)
        filename(user_id)
        send_data salaries.to_csv, filename: (filename+"csv"), :type => "text/csv"
      end

      def filename(user_id)
        if user_id
          user = User.where(:id => user_id).first
          filter_group = user.name
        else
          filter_group = "All Employees"
        end
        filename = "#{ filter_group }_salary_payments_#{ date_from }_#{ date_to }"
      end

  end
end
