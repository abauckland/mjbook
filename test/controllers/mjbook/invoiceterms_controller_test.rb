require 'test_helper'

module Mjbook
  class InvoicetermsControllerTest < ActionController::TestCase
    setup do
      @invoiceterm = invoiceterms(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:invoiceterms)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create invoiceterm" do
      assert_difference('Invoiceterm.count') do
        post :create, invoiceterm: { company_id: @invoiceterm.company_id, terms: @invoiceterm.terms }
      end

      assert_redirected_to invoiceterm_path(assigns(:invoiceterm))
    end

    test "should show invoiceterm" do
      get :show, id: @invoiceterm
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @invoiceterm
      assert_response :success
    end

    test "should update invoiceterm" do
      patch :update, id: @invoiceterm, invoiceterm: { company_id: @invoiceterm.company_id, terms: @invoiceterm.terms }
      assert_redirected_to invoiceterm_path(assigns(:invoiceterm))
    end

    test "should destroy invoiceterm" do
      assert_difference('Invoiceterm.count', -1) do
        delete :destroy, id: @invoiceterm
      end

      assert_redirected_to invoiceterms_path
    end
  end
end
