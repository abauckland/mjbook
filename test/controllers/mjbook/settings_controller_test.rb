require 'test_helper'

module Mjbook
  class SettingsControllerTest < ActionController::TestCase
    setup do
      @setting = settings(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:settings)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create setting" do
      assert_difference('Setting.count') do
        post :create, setting: { company_id: @setting.company_id, email_domain: @setting.email_domain, email_password: @setting.email_password, email_username: @setting.email_username, yearend: @setting.yearend }
      end

      assert_redirected_to setting_path(assigns(:setting))
    end

    test "should show setting" do
      get :show, id: @setting
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @setting
      assert_response :success
    end

    test "should update setting" do
      patch :update, id: @setting, setting: { company_id: @setting.company_id, email_domain: @setting.email_domain, email_password: @setting.email_password, email_username: @setting.email_username, yearend: @setting.yearend }
      assert_redirected_to setting_path(assigns(:setting))
    end

    test "should destroy setting" do
      assert_difference('Setting.count', -1) do
        delete :destroy, id: @setting
      end

      assert_redirected_to settings_path
    end
  end
end
