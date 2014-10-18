require 'test_helper'

module Mjbook
  class ExpendsControllerTest < ActionController::TestCase
    setup do
      @expend = expends(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:expends)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create expend" do
      assert_difference('Expend.count') do
        post :create, expend: { company_id: @expend.company_id, companyaccount_id: @expend.companyaccount_id, date: @expend.date, expend_receipt: @expend.expend_receipt, expense_id: @expend.expense_id, note: @expend.note, paymethod_id: @expend.paymethod_id, price: @expend.price, ref: @expend.ref, total: @expend.total, user_id: @expend.user_id, vat: @expend.vat }
      end

      assert_redirected_to expend_path(assigns(:expend))
    end

    test "should show expend" do
      get :show, id: @expend
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @expend
      assert_response :success
    end

    test "should update expend" do
      patch :update, id: @expend, expend: { company_id: @expend.company_id, companyaccount_id: @expend.companyaccount_id, date: @expend.date, expend_receipt: @expend.expend_receipt, expense_id: @expend.expense_id, note: @expend.note, paymethod_id: @expend.paymethod_id, price: @expend.price, ref: @expend.ref, total: @expend.total, user_id: @expend.user_id, vat: @expend.vat }
      assert_redirected_to expend_path(assigns(:expend))
    end

    test "should destroy expend" do
      assert_difference('Expend.count', -1) do
        delete :destroy, id: @expend
      end

      assert_redirected_to expends_path
    end
  end
end
