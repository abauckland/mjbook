require 'test_helper'

module Mjbook
  class QlinesControllerTest < ActionController::TestCase
    setup do
      @qline = qlines(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:qlines)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create qline" do
      assert_difference('Qline.count') do
        post :create, qline: { cat: @qline.cat, item: @qline.item, line_order: @qline.line_order, linetype: @qline.linetype, note: @qline.note, price: @qline.price, qgroup_id: @qline.qgroup_id, quantity: @qline.quantity, rate: @qline.rate, unit: @qline.unit, vat: @qline.vat, vat_id: @qline.vat_id }
      end

      assert_redirected_to qline_path(assigns(:qline))
    end

    test "should show qline" do
      get :show, id: @qline
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @qline
      assert_response :success
    end

    test "should update qline" do
      patch :update, id: @qline, qline: { cat: @qline.cat, item: @qline.item, line_order: @qline.line_order, linetype: @qline.linetype, note: @qline.note, price: @qline.price, qgroup_id: @qline.qgroup_id, quantity: @qline.quantity, rate: @qline.rate, unit: @qline.unit, vat: @qline.vat, vat_id: @qline.vat_id }
      assert_redirected_to qline_path(assigns(:qline))
    end

    test "should destroy qline" do
      assert_difference('Qline.count', -1) do
        delete :destroy, id: @qline
      end

      assert_redirected_to qlines_path
    end
  end
end
