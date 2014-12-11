require 'test_helper'

module Mjbook
  class MiscexpensesControllerTest < ActionController::TestCase
    setup do
      @miscexpend = miscexpends(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:miscexpends)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create miscexpend" do
      assert_difference('Miscexpend.count') do
        post :create, miscexpend: { company_id: @miscexpend.company_id, date: @miscexpend.date, due_date: @miscexpend.due_date, exp_type: @miscexpend.exp_type, hmrcexpcat_id: @miscexpend.hmrcexpcat_id, item: @miscexpend.item, note: @miscexpend.note, price: @miscexpend.price, project_id: @miscexpend.project_id, provider_id: @miscexpend.provider_id, provider_ref: @miscexpend.provider_ref, receipt: @miscexpend.receipt, ref: @miscexpend.ref, state: @miscexpend.state, total: @miscexpend.total, user_id: @miscexpend.user_id, vat: @miscexpend.vat }
      end

      assert_redirected_to miscexpend_path(assigns(:miscexpend))
    end

    test "should show miscexpend" do
      get :show, id: @miscexpend
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @miscexpend
      assert_response :success
    end

    test "should update miscexpend" do
      patch :update, id: @miscexpend, miscexpend: { company_id: @miscexpend.company_id, date: @miscexpend.date, due_date: @miscexpend.due_date, exp_type: @miscexpend.exp_type, hmrcexpcat_id: @miscexpend.hmrcexpcat_id, item: @miscexpend.item, note: @miscexpend.note, price: @miscexpend.price, project_id: @miscexpend.project_id, provider_id: @miscexpend.provider_id, provider_ref: @miscexpend.provider_ref, receipt: @miscexpend.receipt, ref: @miscexpend.ref, state: @miscexpend.state, total: @miscexpend.total, user_id: @miscexpend.user_id, vat: @miscexpend.vat }
      assert_redirected_to miscexpend_path(assigns(:miscexpend))
    end

    test "should destroy miscexpend" do
      assert_difference('Miscexpend.count', -1) do
        delete :destroy, id: @miscexpend
      end

      assert_redirected_to miscexpends_path
    end
  end
end
