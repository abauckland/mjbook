require_dependency "mjbook/application_controller"

module Mjbook
  class HmrcexpcatsController < ApplicationController
    before_action :set_hmrcexpcat, only: [:show, :edit, :update, :destroy]

    # GET /hmrcexpcats
    def index
      @hmrcexpcats = Hmrcexpcat.all
    end

    # GET /hmrcexpcats/1
    def show
    end

    # GET /hmrcexpcats/new
    def new
      @hmrcexpcat = Hmrcexpcat.new
    end

    # GET /hmrcexpcats/1/edit
    def edit
    end

    # POST /hmrcexpcats
    def create
      @hmrcexpcat = Hmrcexpcat.new(hmrcexpcat_params)

      if @hmrcexpcat.save
        redirect_to @hmrcexpcat, notice: 'Hmrcexpcat was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /hmrcexpcats/1
    def update
      if @hmrcexpcat.update(hmrcexpcat_params)
        redirect_to @hmrcexpcat, notice: 'Hmrcexpcat was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /hmrcexpcats/1
    def destroy
      @hmrcexpcat.destroy
      redirect_to hmrcexpcats_url, notice: 'Hmrcexpcat was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_hmrcexpcat
        @hmrcexpcat = Hmrcexpcat.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def hmrcexpcat_params
        params.require(:hmrcexpcat).permit(:company_id, :category, :group)
      end
  end
end
