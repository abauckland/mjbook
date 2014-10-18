require_dependency "mjbook/application_controller"

module Mjbook
  class SalariesController < ApplicationController
    before_action :set_salary, only: [:show, :edit, :update, :destroy]
    before_action :set_users, only: [:new, :edit]

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
              end
            end   
          else
            if params[:date_from] != ""
              if params[:date_to] != ""
                @salaries = Salary.joins(:project).where(:date => params[:date_from]..params[:date_to], 'mjbook_projects.company_id' => current_user.company_id)          
              else
                @salaries = Salary.joins(:project).where('date > ? AND mjbook_projects.company_id = ?', params[:date_from], current_user.company_id)  
              end  
            else  
              if params[:date_to] != ""
                @salaries = Salary.joins(:project).where('date < ? AND mjbook_projects.company_id = ?', params[:date_to], current_user.company_id)            
              else
                @salaries = Salary.joins(:project).where('mjbook_projects.company_id' => current_user.company_id)
              end     
            end
          end   
       
          if params[:commit] == 'pdf'          
            pdf_salary_index(@salaries, params[:user_id], params[:date_from], params[:date_to])      
          end
              
       else
         @salaries = Salary.joins(:project).where('mjbook_projects.company_id' => current_user.company_id)       
       end          

       #selected parameters for filter form     
       @users = User.where(:company_id => current_user.company_id)
       @user = params[:user_id]
       @date_from = params[:date_from]
       @date_to = params[:date_to]   

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
      
      def pdf_employee_index(salaries, user_id, date_from, date_to)
         user = User.where(:id => user_id).first if user_id

        if user
          filter_group =user.name
        else
          filter_group = "All Employees"
        end
         
        filename = "Employee_salary_payments_#{ filter_group }_#{ date_from }_#{ date_to }.pdf"
                   
        document = Prawn::Document.new(
          :page_size => "A4",
          :page_layout => :landscape,
          :margin => [10.mm, 10.mm, 5.mm, 10.mm]
        ) do |pdf|      
          table_indexes(salaries, 'terms', nil, nil, nil, filename, pdf)      
        end
  
        send_data document.render, filename: filename, :type => "application/pdf"        
      end

  end
end
