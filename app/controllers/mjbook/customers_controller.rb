require_dependency "mjbook/application_controller"

module Mjbook
  class CustomersController < ApplicationController
    before_action :set_customer, only: [:show, :edit, :update, :destroy]
    before_action :set_customers, only: [:index, :print]

    include PrintIndexes

    # GET /customers
    def index
      authorize @customers
    end

    # GET /customers/1
    def show
      authorize @customer
    end

    # GET /customers/new
    def new
      @customer = Customer.new
    end

    # GET /customers/1/edit
    def edit
      authorize @customer
    end

    # POST /customers
    def create
      @customer = Customer.new(customer_params)

      if @customer.save
        redirect_to customers_path, notice: 'Customer was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /customers/1
    def update
      authorize @customer
      if @customer.update(customer_params)
        redirect_to customers_path, notice: 'Customer was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /customers/1
    def destroy
      authorize @customer
      @customer.destroy
      redirect_to customers_path, notice: 'Customer was successfully destroyed.'
    end


    def print
      authorize @customers
      filename = "Customers.pdf"

      document = Prawn::Document.new(
        :page_size => "A4",
        :page_layout => :landscape,
        :margin => [10.mm, 10.mm, 5.mm, 10.mm]
      ) do |pdf|
        table_indexes(@customers, 'customer', nil, nil, nil, filename, pdf)
      end

      send_data document.render, filename: filename, :type => "application/pdf"
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_customer
        @customer = Customer.find(params[:id])
      end

      def set_customers
        @customers = policy_scope(Customer)
      end

      # Only allow a trusted parameter "white list" through.
      def customer_params
        params.require(:customer).permit(:company_id, :title, :first_name, :surname, :position, :address_1, :address_2, :city, :county, :country, :postcode, :phone, :alt_phone, :email, :company_name, :notes)
      end

  end
end
