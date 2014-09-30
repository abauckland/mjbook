require 'test_helper'

module Mjbook
  class QgroupsControllerTest < ActionController::TestCase
    setup do
      @qgroup = qgroups(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:qgroups)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create qgroup" do
      assert_difference('Qgroup.count') do
        post :create, qgroup: { quote_id: @qgroup.quote_id, ref: @qgroup.ref, sub_price: @qgroup.sub_price, sub_vat: @qgroup.sub_vat, text: @qgroup.text }
      end

      assert_redirected_to qgroup_path(assigns(:qgroup))
    end

    test "should show qgroup" do
      get :show, id: @qgroup
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @qgroup
      assert_response :success
    end

    test "should update qgroup" do
      patch :update, id: @qgroup, qgroup: { quote_id: @qgroup.quote_id, ref: @qgroup.ref, sub_price: @qgroup.sub_price, sub_vat: @qgroup.sub_vat, text: @qgroup.text }
      assert_redirected_to qgroup_path(assigns(:qgroup))
    end

    test "should destroy qgroup" do
      assert_difference('Qgroup.count', -1) do
        delete :destroy, id: @qgroup
      end

      assert_redirected_to qgroups_path
    end
  end
end
