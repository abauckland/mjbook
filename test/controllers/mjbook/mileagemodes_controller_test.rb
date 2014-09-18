require 'test_helper'

module Mjbook
  class MileagemodesControllerTest < ActionController::TestCase
    setup do
      @mileagemode = mileagemodes(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:mileagemodes)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create mileagemode" do
      assert_difference('Mileagemode.count') do
        post :create, mileagemode: { hmrc_rate: @mileagemode.hmrc_rate, mode: @mileagemode.mode, rate: @mileagemode.rate }
      end

      assert_redirected_to mileagemode_path(assigns(:mileagemode))
    end

    test "should show mileagemode" do
      get :show, id: @mileagemode
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @mileagemode
      assert_response :success
    end

    test "should update mileagemode" do
      patch :update, id: @mileagemode, mileagemode: { hmrc_rate: @mileagemode.hmrc_rate, mode: @mileagemode.mode, rate: @mileagemode.rate }
      assert_redirected_to mileagemode_path(assigns(:mileagemode))
    end

    test "should destroy mileagemode" do
      assert_difference('Mileagemode.count', -1) do
        delete :destroy, id: @mileagemode
      end

      assert_redirected_to mileagemodes_path
    end
  end
end
