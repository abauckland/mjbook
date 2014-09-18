require 'test_helper'

module Mjbook
  class ExpenseexpendsControllerTest < ActionController::TestCase
    setup do
      @expenseexpend = expenseexpends(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:expenseexpends)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create expenseexpend" do
      assert_difference('Expenseexpend.count') do
        post :create, expenseexpend: { expenditure_id: @expenseexpend.expenditure_id, expense_id: @expenseexpend.expense_id }
      end

      assert_redirected_to expenseexpend_path(assigns(:expenseexpend))
    end

    test "should show expenseexpend" do
      get :show, id: @expenseexpend
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @expenseexpend
      assert_response :success
    end

    test "should update expenseexpend" do
      patch :update, id: @expenseexpend, expenseexpend: { expenditure_id: @expenseexpend.expenditure_id, expense_id: @expenseexpend.expense_id }
      assert_redirected_to expenseexpend_path(assigns(:expenseexpend))
    end

    test "should destroy expenseexpend" do
      assert_difference('Expenseexpend.count', -1) do
        delete :destroy, id: @expenseexpend
      end

      assert_redirected_to expenseexpends_path
    end
  end
end
