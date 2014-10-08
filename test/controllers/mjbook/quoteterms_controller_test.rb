require 'test_helper'

module Mjbook
  class QuotetermsControllerTest < ActionController::TestCase
    setup do
      @quoteterm = quoteterms(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:quoteterms)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create quoteterm" do
      assert_difference('Quoteterm.count') do
        post :create, quoteterm: { company_id: @quoteterm.company_id, terms: @quoteterm.terms }
      end

      assert_redirected_to quoteterm_path(assigns(:quoteterm))
    end

    test "should show quoteterm" do
      get :show, id: @quoteterm
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @quoteterm
      assert_response :success
    end

    test "should update quoteterm" do
      patch :update, id: @quoteterm, quoteterm: { company_id: @quoteterm.company_id, terms: @quoteterm.terms }
      assert_redirected_to quoteterm_path(assigns(:quoteterm))
    end

    test "should destroy quoteterm" do
      assert_difference('Quoteterm.count', -1) do
        delete :destroy, id: @quoteterm
      end

      assert_redirected_to quoteterms_path
    end
  end
end
