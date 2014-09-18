require 'test_helper'

module Mjbook
  class InvoicemethodsControllerTest < ActionController::TestCase
    setup do
      @invoicemethod = invoicemethods(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:invoicemethods)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create invoicemethod" do
      assert_difference('Invoicemethod.count') do
        post :create, invoicemethod: { method: @invoicemethod.method }
      end

      assert_redirected_to invoicemethod_path(assigns(:invoicemethod))
    end

    test "should show invoicemethod" do
      get :show, id: @invoicemethod
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @invoicemethod
      assert_response :success
    end

    test "should update invoicemethod" do
      patch :update, id: @invoicemethod, invoicemethod: { method: @invoicemethod.method }
      assert_redirected_to invoicemethod_path(assigns(:invoicemethod))
    end

    test "should destroy invoicemethod" do
      assert_difference('Invoicemethod.count', -1) do
        delete :destroy, id: @invoicemethod
      end

      assert_redirected_to invoicemethods_path
    end
  end
end
