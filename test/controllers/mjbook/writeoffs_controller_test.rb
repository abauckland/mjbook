require 'test_helper'

module Mjbook
  class WriteoffsControllerTest < ActionController::TestCase
    setup do
      @writeoff = writeoffs(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:writeoffs)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create writeoff" do
      assert_difference('Writeoff.count') do
        post :create, writeoff: { company_id: @writeoff.company_id, date: @writeoff.date, notes: @writeoff.notes, price: @writeoff.price, ref: @writeoff.ref, total: @writeoff.total, vat: @writeoff.vat }
      end

      assert_redirected_to writeoff_path(assigns(:writeoff))
    end

    test "should show writeoff" do
      get :show, id: @writeoff
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @writeoff
      assert_response :success
    end

    test "should update writeoff" do
      patch :update, id: @writeoff, writeoff: { company_id: @writeoff.company_id, date: @writeoff.date, notes: @writeoff.notes, price: @writeoff.price, ref: @writeoff.ref, total: @writeoff.total, vat: @writeoff.vat }
      assert_redirected_to writeoff_path(assigns(:writeoff))
    end

    test "should destroy writeoff" do
      assert_difference('Writeoff.count', -1) do
        delete :destroy, id: @writeoff
      end

      assert_redirected_to writeoffs_path
    end
  end
end
