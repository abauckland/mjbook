require 'test_helper'

module Mjbook
  class JournalsControllerTest < ActionController::TestCase
    setup do
      @journal = journals(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:journals)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create journal" do
      assert_difference('Journal.count') do
        post :create, journal: { adjustment: @journal.adjustment, expenditem_id: @journal.expenditem_id, note: @journal.note, paymentitem_id: @journal.paymentitem_id, period_id: @journal.period_id }
      end

      assert_redirected_to journal_path(assigns(:journal))
    end

    test "should show journal" do
      get :show, id: @journal
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @journal
      assert_response :success
    end

    test "should update journal" do
      patch :update, id: @journal, journal: { adjustment: @journal.adjustment, expenditem_id: @journal.expenditem_id, note: @journal.note, paymentitem_id: @journal.paymentitem_id, period_id: @journal.period_id }
      assert_redirected_to journal_path(assigns(:journal))
    end

    test "should destroy journal" do
      assert_difference('Journal.count', -1) do
        delete :destroy, id: @journal
      end

      assert_redirected_to journals_path
    end
  end
end
