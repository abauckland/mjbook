require 'test_helper'

module Mjbook
  class SuppliersControllerTest < ActionController::TestCase
    setup do
      @supplier = suppliers(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:suppliers)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create supplier" do
      assert_difference('Supplier.count') do
        post :create, supplier: { address_1: @supplier.address_1, address_2: @supplier.address_2, alt_phone: @supplier.alt_phone, city: @supplier.city, company: @supplier.company, country: @supplier.country, county: @supplier.county, email: @supplier.email, first_name: @supplier.first_name, notes: @supplier.notes, phone: @supplier.phone, position: @supplier.position, postcode: @supplier.postcode, surname: @supplier.surname, title: @supplier.title }
      end

      assert_redirected_to supplier_path(assigns(:supplier))
    end

    test "should show supplier" do
      get :show, id: @supplier
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @supplier
      assert_response :success
    end

    test "should update supplier" do
      patch :update, id: @supplier, supplier: { address_1: @supplier.address_1, address_2: @supplier.address_2, alt_phone: @supplier.alt_phone, city: @supplier.city, company: @supplier.company, country: @supplier.country, county: @supplier.county, email: @supplier.email, first_name: @supplier.first_name, notes: @supplier.notes, phone: @supplier.phone, position: @supplier.position, postcode: @supplier.postcode, surname: @supplier.surname, title: @supplier.title }
      assert_redirected_to supplier_path(assigns(:supplier))
    end

    test "should destroy supplier" do
      assert_difference('Supplier.count', -1) do
        delete :destroy, id: @supplier
      end

      assert_redirected_to suppliers_path
    end
  end
end
