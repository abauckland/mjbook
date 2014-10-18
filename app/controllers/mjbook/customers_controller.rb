require_dependency "mjbook/application_controller"

module Mjbook
  class CustomersController < ApplicationController
    before_action :set_customer, only: [:show, :edit, :update, :destroy]

    include PrintIndexes
    
    # GET /customers
    def index
      @customers = Customer.all
    end

    # GET /customers/1
    def show
    end

    # GET /customers/new
    def new
      @customer = Customer.new
    end

    # GET /customers/1/edit
    def edit
    end

    # POST /customers
    def create
      @customer = Customer.new(customer_params)

      if @customer.save
        redirect_to @customer, notice: 'Customer was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /customers/1
    def update
      if @customer.update(customer_params)
        redirect_to @customer, notice: 'Customer was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /customers/1
    def destroy
      @customer.destroy
      redirect_to customers_url, notice: 'Customer was successfully destroyed.'
    end


    def print
        
      customers = Customer.where(:company_id => current_user.company_id)
         
      filename = "Customers.pdf"
                 
      document = Prawn::Document.new(
        :page_size => "A4",
        :page_layout => :landscape,
        :margin => [10.mm, 10.mm, 5.mm, 10.mm]
      ) do |pdf|      
        table_indexes(customers, 'customer', nil, nil, nil, filename, pdf)      
      end

      send_data document.render, filename: filename, :type => "application/pdf"        
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_customer
        @customer = Customer.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def customer_params
        params.require(:customer).permit(:company_id, :title, :first_name, :surname, :position, :address_1, :address_2, :city, :county, :country, :postcode, :phone, :alt_phone, :email, :company_name, :notes)
      end

  end
end
