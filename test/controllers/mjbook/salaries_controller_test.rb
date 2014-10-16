require 'test_helper'

module Mjbook
  class SalariesControllerTest < ActionController::TestCase
    setup do
      @salary = salaries(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:salaries)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create salary" do
      assert_difference('Salary.count') do
        post :create, salary: { company_id: @salary.company_id, date: @salary.date, paid: @salary.paid, user_id: @salary.user_id }
      end

      assert_redirected_to salary_path(assigns(:salary))
    end

    test "should show salary" do
      get :show, id: @salary
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @salary
      assert_response :success
    end

    test "should update salary" do
      patch :update, id: @salary, salary: { company_id: @salary.company_id, date: @salary.date, paid: @salary.paid, user_id: @salary.user_id }
      assert_redirected_to salary_path(assigns(:salary))
    end

    test "should destroy salary" do
      assert_difference('Salary.count', -1) do
        delete :destroy, id: @salary
      end

      assert_redirected_to salaries_path
    end
  end
end
