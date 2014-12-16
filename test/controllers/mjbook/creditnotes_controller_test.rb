require 'test_helper'

module Mjbook
  class CreditnotesControllerTest < ActionController::TestCase
    setup do
      @creditnote = creditnotes(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:creditnotes)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create creditnote" do
      assert_difference('Creditnote.count') do
        post :create, creditnote: { company_id: @creditnote.company_id, date: @creditnote.date, notes: @creditnote.notes, price: @creditnote.price, ref: @creditnote.ref, total: @creditnote.total, vat: @creditnote.vat }
      end

      assert_redirected_to creditnote_path(assigns(:creditnote))
    end

    test "should show creditnote" do
      get :show, id: @creditnote
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @creditnote
      assert_response :success
    end

    test "should update creditnote" do
      patch :update, id: @creditnote, creditnote: { company_id: @creditnote.company_id, date: @creditnote.date, notes: @creditnote.notes, price: @creditnote.price, ref: @creditnote.ref, total: @creditnote.total, vat: @creditnote.vat }
      assert_redirected_to creditnote_path(assigns(:creditnote))
    end

    test "should destroy creditnote" do
      assert_difference('Creditnote.count', -1) do
        delete :destroy, id: @creditnote
      end

      assert_redirected_to creditnotes_path
    end
  end
end
