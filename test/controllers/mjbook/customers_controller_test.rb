require 'test_helper'

module Mjbook
  class CustomersControllerTest < ActionController::TestCase
    setup do
      @customer = customers(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:customers)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create customer" do
      assert_difference('Customer.count') do
        post :create, customer: { address_1: @customer.address_1, address_2: @customer.address_2, alt_phone: @customer.alt_phone, city: @customer.city, company: @customer.company, country: @customer.country, county: @customer.county, email: @customer.email, first_name: @customer.first_name, notes: @customer.notes, phone: @customer.phone, position: @customer.position, postcode: @customer.postcode, surname: @customer.surname, title: @customer.title }
      end

      assert_redirected_to customer_path(assigns(:customer))
    end

    test "should show customer" do
      get :show, id: @customer
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @customer
      assert_response :success
    end

    test "should update customer" do
      patch :update, id: @customer, customer: { address_1: @customer.address_1, address_2: @customer.address_2, alt_phone: @customer.alt_phone, city: @customer.city, company: @customer.company, country: @customer.country, county: @customer.county, email: @customer.email, first_name: @customer.first_name, notes: @customer.notes, phone: @customer.phone, position: @customer.position, postcode: @customer.postcode, surname: @customer.surname, title: @customer.title }
      assert_redirected_to customer_path(assigns(:customer))
    end

    test "should destroy customer" do
      assert_difference('Customer.count', -1) do
        delete :destroy, id: @customer
      end

      assert_redirected_to customers_path
    end
  end
end
