require 'test_helper'

module Mjbook
  class CompanyaccountsControllerTest < ActionController::TestCase
    setup do
      @companyaccount = companyaccounts(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:companyaccounts)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create companyaccount" do
      assert_difference('Companyaccount.count') do
        post :create, companyaccount: { code: @companyaccount.code, company_id: @companyaccount.company_id, name: @companyaccount.name, number: @companyaccount.number, provider: @companyaccount.provider }
      end

      assert_redirected_to companyaccount_path(assigns(:companyaccount))
    end

    test "should show companyaccount" do
      get :show, id: @companyaccount
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @companyaccount
      assert_response :success
    end

    test "should update companyaccount" do
      patch :update, id: @companyaccount, companyaccount: { code: @companyaccount.code, company_id: @companyaccount.company_id, name: @companyaccount.name, number: @companyaccount.number, provider: @companyaccount.provider }
      assert_redirected_to companyaccount_path(assigns(:companyaccount))
    end

    test "should destroy companyaccount" do
      assert_difference('Companyaccount.count', -1) do
        delete :destroy, id: @companyaccount
      end

      assert_redirected_to companyaccounts_path
    end
  end
end
