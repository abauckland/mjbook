require 'test_helper'

module Mjbook
  class ProductcategoriesControllerTest < ActionController::TestCase
    setup do
      @productcategory = productcategories(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:productcategories)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create productcategory" do
      assert_difference('Productcategory.count') do
        post :create, productcategory: { name: @productcategory.name }
      end

      assert_redirected_to productcategory_path(assigns(:productcategory))
    end

    test "should show productcategory" do
      get :show, id: @productcategory
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @productcategory
      assert_response :success
    end

    test "should update productcategory" do
      patch :update, id: @productcategory, productcategory: { name: @productcategory.name }
      assert_redirected_to productcategory_path(assigns(:productcategory))
    end

    test "should destroy productcategory" do
      assert_difference('Productcategory.count', -1) do
        delete :destroy, id: @productcategory
      end

      assert_redirected_to productcategories_path
    end
  end
end
