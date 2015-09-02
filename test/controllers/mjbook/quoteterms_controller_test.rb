require 'test_helper'

module Mjbook
  class QuotetermsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

    setup do
      @quoteterm = quoteterms(:thirty_days)
      @user = users(:admin)
    end

    test "not authenticated should get redirect" do
      get :index
      assert_response :redirect
    end

    test "should get index" do
      sign_in @user

      get :index
      assert_response :success
      assert_not_nil assigns(:quoteterms)
    end

    test "should get new" do
      sign_in @user

      get :new
      assert_response :success
    end

    test "should create quoteterm" do
      sign_in @user

      assert_difference('Quoteterm.count') do
        post :create, quoteterm: { company_id: @quoteterm.company_id, terms: @quoteterm.terms }
      end

      assert_redirected_to quoteterm_path(assigns(:quoteterm))
    end

    test "should get edit" do
      sign_in @user

      get :edit, id: @quoteterm
      assert_response :success
    end

    test "should update quoteterm" do
      sign_in @user

      patch :update, id: @quoteterm, quoteterm: { company_id: @quoteterm.company_id, terms: @quoteterm.terms }
      assert_redirected_to quoteterm_path(assigns(:quoteterm))
    end

    test "should destroy quoteterm" do
      sign_in @user

      assert_difference('Quoteterm.count', -1) do
        delete :destroy, id: @quoteterm
      end

      assert_redirected_to quoteterms_path
    end

#print
    test "should create pdf of terms" do
      sign_in @user

      company = companies(:myhq)
      get :print, id: company.id
      assert_response :success
    end

  end
end
