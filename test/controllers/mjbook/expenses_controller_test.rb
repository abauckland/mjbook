require 'test_helper'

module Mjbook
  class ExpensesControllerTest < ActionController::TestCase
    setup do
      @expense = expenses(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:expenses)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create expense" do
      assert_difference('Expense.count') do
        post :create, expense: { amount: @expense.amount, due_date: @expense.due_date, hmrcexpcat_id: @expense.hmrcexpcat_id, issue_date: @expense.issue_date, project_id: @expense.project_id, receipt: @expense.receipt, recurrence: @expense.recurrence, ref: @expense.ref, status: @expense.status, supplier_id: @expense.supplier_id, supplier_ref: @expense.supplier_ref, user_id: @expense.user_id, vat: @expense.vat }
      end

      assert_redirected_to expense_path(assigns(:expense))
    end

    test "should show expense" do
      get :show, id: @expense
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @expense
      assert_response :success
    end

    test "should update expense" do
      patch :update, id: @expense, expense: { amount: @expense.amount, due_date: @expense.due_date, hmrcexpcat_id: @expense.hmrcexpcat_id, issue_date: @expense.issue_date, project_id: @expense.project_id, receipt: @expense.receipt, recurrence: @expense.recurrence, ref: @expense.ref, status: @expense.status, supplier_id: @expense.supplier_id, supplier_ref: @expense.supplier_ref, user_id: @expense.user_id, vat: @expense.vat }
      assert_redirected_to expense_path(assigns(:expense))
    end

    test "should destroy expense" do
      assert_difference('Expense.count', -1) do
        delete :destroy, id: @expense
      end

      assert_redirected_to expenses_path
    end
  end
end
