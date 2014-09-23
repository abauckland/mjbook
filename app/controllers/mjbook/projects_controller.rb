require_dependency "mjbook/application_controller"

module Mjbook
  class ProjectsController < ApplicationController
    before_action :set_project, only: [:show, :edit, :update, :destroy]
    before_action :set_customers, only: [:new, :edit]

    # GET /projects
    def index
      @projects = Project.all
    end

    # GET /projects/1
    def show
    end

    # GET /projects/new
    def new
      @project = Project.new

    end

    # GET /projects/1/edit
    def edit
    end

    # POST /projects
    def create
      @project = Project.new(project_params)


      if @project.save
        redirect_to @project, notice: 'Project was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /projects/1
    def update
      if @project.update(project_params)
        redirect_to @project, notice: 'Project was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /projects/1
    def destroy
      @project.destroy
      redirect_to projects_url, notice: 'Project was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_project
        @project = Project.find(params[:id])
      end

      def set_customers      
        @customers = Customer.where(:company_id => current_user.company_id)
      end
      
      # Only allow a trusted parameter "white list" through.
      def project_params
        params.require(:project).permit(:company_id, :ref, :title, :customer_id, :description, :invoicemethod_id, :customer_ref)
      end
  end
end
