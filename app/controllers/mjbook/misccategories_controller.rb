require_dependency "mjbook/application_controller"

module Mjbook
  class MisccategoriesController < ApplicationController
    before_action :set_misccategories, only: [:index, :list_categories]
    before_action :set_misccategory, only: [:show, :edit, :update, :destroy]

    # GET /misccategories
    def index
    end
    
    def list_categories
      render :json => @misccategories
    end


    # GET /misccategories/new
    def new
      @misccategory = Misccategory.new
    end

    # GET /misccategories/1/edit
    def edit
    end

    # POST /misccategories
    def create
      @misccategory = Misccategory.new(misccategory_params)

      if @misccategory.save
        redirect_to @misccategory, notice: 'misccategory was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /misccategories/1
    def update
      if @misccategory.update(misccategory_params)
        redirect_to @misccategory, notice: 'misccategory was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /misccategories/1
    def destroy
      @misccategory.destroy
      redirect_to misccategories_url, notice: 'misccategory was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_misccategories
        @misccategories = Misccategory.where(:company_id => current_user.company_id).order(:name)
      end
      
      def set_misccategory
        @misccategory = Misccategory.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def misccategory_params
        params.require(:misccategory).permit(:company_id, :name)
      end
  end
end
