require 'test_helper'

module Mjbook
  class IngroupsControllerTest < ActionController::TestCase
    setup do
      @ingroup = ingroups(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:ingroups)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create ingroup" do
      assert_difference('Ingroup.count') do
        post :create, ingroup: { group_order: @ingroup.group_order, invoice_id: @ingroup.invoice_id, price: @ingroup.price, ref: @ingroup.ref, text: @ingroup.text, total: @ingroup.total, vat_due: @ingroup.vat_due }
      end

      assert_redirected_to ingroup_path(assigns(:ingroup))
    end

    test "should show ingroup" do
      get :show, id: @ingroup
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @ingroup
      assert_response :success
    end

    test "should update ingroup" do
      patch :update, id: @ingroup, ingroup: { group_order: @ingroup.group_order, invoice_id: @ingroup.invoice_id, price: @ingroup.price, ref: @ingroup.ref, text: @ingroup.text, total: @ingroup.total, vat_due: @ingroup.vat_due }
      assert_redirected_to ingroup_path(assigns(:ingroup))
    end

    test "should destroy ingroup" do
      assert_difference('Ingroup.count', -1) do
        delete :destroy, id: @ingroup
      end

      assert_redirected_to ingroups_path
    end
  end
end
