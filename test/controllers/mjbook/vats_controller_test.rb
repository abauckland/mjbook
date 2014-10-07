require 'test_helper'

module Mjbook
  class VatsControllerTest < ActionController::TestCase
    setup do
      @vat = vats(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:vats)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create vat" do
      assert_difference('Vat.count') do
        post :create, vat: { cat: @vat.cat, rate: @vat.rate }
      end

      assert_redirected_to vat_path(assigns(:vat))
    end

    test "should show vat" do
      get :show, id: @vat
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @vat
      assert_response :success
    end

    test "should update vat" do
      patch :update, id: @vat, vat: { cat: @vat.cat, rate: @vat.rate }
      assert_redirected_to vat_path(assigns(:vat))
    end

    test "should destroy vat" do
      assert_difference('Vat.count', -1) do
        delete :destroy, id: @vat
      end

      assert_redirected_to vats_path
    end
  end
end
