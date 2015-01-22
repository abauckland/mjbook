require_dependency "mjbook/application_controller"

module Mjbook
  class ProjectsController < ApplicationController
    before_action :set_project, only: [:show, :edit, :update, :destroy]
    before_action :set_projects, only: [:index, :print]
    before_action :set_customers, only: [:new, :edit, :update, :create]

    include PrintIndexes
    
    # GET /projects
    def index
      authorize @projects
    end

    # GET /projects/1
    def show
      authorize @project
    end

    # GET /projects/new
    def new
      @project = Project.new
    end

    # GET /projects/1/edit
    def edit
      authorize @project
    end

    # POST /projects
    def create
      @project = Project.new(project_params)


      if @project.save
        redirect_to projects_path, notice: 'Project was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /projects/1
    def update
      authorize @project
      if @project.update(project_params)
        redirect_to projects_path, notice: 'Project was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /projects/1
    def destroy
      authorize @project
      @project.destroy
      redirect_to projects_path, notice: 'Project was successfully destroyed.'
    end

    def print

      filename = "Projects.pdf"
                 
      document = Prawn::Document.new(
        :page_size => "A4",
        :page_layout => :landscape,
        :margin => [10.mm, 10.mm, 5.mm, 10.mm]
      ) do |pdf|      
        table_indexes(@projects, 'project', nil, nil, nil, filename, pdf)      
      end

      send_data document.render, filename: filename, :type => "application/pdf"        
    end
    
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_project
        @project = Project.find(params[:id])
      end

      def set_projects
        @projects = policy_scope(Project)
      end

      def set_customers      
        @customers = policy_scope(Customer)
      end
      
      # Only allow a trusted parameter "white list" through.
      def project_params
        params.require(:project).permit(:company_id, :ref, :title, :customer_id, :description, :invoicemethod_id, :customer_ref)
      end
  end
end
