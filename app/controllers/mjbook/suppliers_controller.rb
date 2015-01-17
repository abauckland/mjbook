require_dependency "mjbook/application_controller"

module Mjbook
  class SuppliersController < ApplicationController
    before_action :set_supplier, only: [:show, :edit, :update, :destroy]
    before_action :set_suppliers, only: [:index, :print]

    include PrintIndexes
    
    # GET /suppliers
    def index
    end

    # GET /suppliers/1
    def show
    end

    # GET /suppliers/new
    def new
      @supplier = Supplier.new
    end

    # GET /suppliers/1/edit
    def edit
    end

    # POST /suppliers
    def create
      @supplier = Supplier.new(supplier_params)

      if @supplier.save
        redirect_to suppliers_path, notice: 'Supplier was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /suppliers/1
    def update
      if @supplier.update(supplier_params)
        redirect_to suppliers_path, notice: 'Supplier was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /suppliers/1
    def destroy
      @supplier.destroy
      redirect_to suppliers_path, notice: 'Supplier was successfully destroyed.'
    end

    def print
         
      filename = "Suppliers.pdf"
                 
      document = Prawn::Document.new(
        :page_size => "A4",
        :page_layout => :landscape,
        :margin => [10.mm, 10.mm, 5.mm, 10.mm]
      ) do |pdf|      
        table_indexes(@suppliers, 'supplier', nil, nil, nil, filename, pdf)      
      end

      send_data document.render, filename: filename, :type => "application/pdf"        
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_supplier
        @supplier = Supplier.find(params[:id])
      end

      def set_suppliers
        @suppliers = policy_scope(Supplier).order(:company_name)
      end

      # Only allow a trusted parameter "white list" through.
      def supplier_params
        params.require(:supplier).permit(:company_id, :title, :first_name, :surname, :position, :address_1, :address_2, :city, :county, :country, :postcode, :phone, :alt_phone, :email, :company_name, :notes, :vat_no)
      end
  end
end
