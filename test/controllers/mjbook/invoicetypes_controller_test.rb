require 'test_helper'

module Mjbook
  class InvoicetypesControllerTest < ActionController::TestCase
    setup do
      @invoicetype = invoicetypes(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:invoicetypes)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create invoicetype" do
      assert_difference('Invoicetype.count') do
        post :create, invoicetype: { text: @invoicetype.text }
      end

      assert_redirected_to invoicetype_path(assigns(:invoicetype))
    end

    test "should show invoicetype" do
      get :show, id: @invoicetype
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @invoicetype
      assert_response :success
    end

    test "should update invoicetype" do
      patch :update, id: @invoicetype, invoicetype: { text: @invoicetype.text }
      assert_redirected_to invoicetype_path(assigns(:invoicetype))
    end

    test "should destroy invoicetype" do
      assert_difference('Invoicetype.count', -1) do
        delete :destroy, id: @invoicetype
      end

      assert_redirected_to invoicetypes_path
    end
  end
end
