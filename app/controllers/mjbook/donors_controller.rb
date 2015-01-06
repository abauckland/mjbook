require_dependency "mjbook/application_controller"

module Mjbook
  class DonorsController < ApplicationController
    before_action :set_donor, only: [:show, :edit, :update, :destroy]

    # GET /donors
    def index
      @donors = Donor.all
    end

    # GET /donors/1
    def show
    end

    # GET /donors/new
    def new
      @donor = Donor.new
    end

    # GET /donors/1/edit
    def edit
    end

    # POST /donors
    def create
      @donor = Donor.new(donor_params)

      if @donor.save
        redirect_to @donor, notice: 'Donor was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /donors/1
    def update
      if @donor.update(donor_params)
        redirect_to @donor, notice: 'Donor was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /donors/1
    def destroy
      @donor.destroy
      redirect_to donors_url, notice: 'Donor was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_donor
        @donor = Donor.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def donor_params
        params.require(:donor).permit(:title, :first_name, :surname, :house, :postcode)
      end
  end
end
