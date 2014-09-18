require 'test_helper'

module Mjbook
  class HmrcexpcatsControllerTest < ActionController::TestCase
    setup do
      @hmrcexpcat = hmrcexpcats(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:hmrcexpcats)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create hmrcexpcat" do
      assert_difference('Hmrcexpcat.count') do
        post :create, hmrcexpcat: { category: @hmrcexpcat.category, type: @hmrcexpcat.type }
      end

      assert_redirected_to hmrcexpcat_path(assigns(:hmrcexpcat))
    end

    test "should show hmrcexpcat" do
      get :show, id: @hmrcexpcat
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @hmrcexpcat
      assert_response :success
    end

    test "should update hmrcexpcat" do
      patch :update, id: @hmrcexpcat, hmrcexpcat: { category: @hmrcexpcat.category, type: @hmrcexpcat.type }
      assert_redirected_to hmrcexpcat_path(assigns(:hmrcexpcat))
    end

    test "should destroy hmrcexpcat" do
      assert_difference('Hmrcexpcat.count', -1) do
        delete :destroy, id: @hmrcexpcat
      end

      assert_redirected_to hmrcexpcats_path
    end
  end
end
