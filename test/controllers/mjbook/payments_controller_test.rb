require 'test_helper'

module Mjbook
  class PaymentsControllerTest < ActionController::TestCase
    setup do
      @payment = payments(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:payments)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create payment" do
      assert_difference('Payment.count') do
        post :create, payment: { companyaccount_id: @payment.companyaccount_id, date: @payment.date, invoice_id: @payment.invoice_id, note: @payment.note, paymethod_id: @payment.paymethod_id, price: @payment.price, total: @payment.total, user_id: @payment.user_id, vat: @payment.vat }
      end

      assert_redirected_to payment_path(assigns(:payment))
    end

    test "should show payment" do
      get :show, id: @payment
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @payment
      assert_response :success
    end

    test "should update payment" do
      patch :update, id: @payment, payment: { companyaccount_id: @payment.companyaccount_id, date: @payment.date, invoice_id: @payment.invoice_id, note: @payment.note, paymethod_id: @payment.paymethod_id, price: @payment.price, total: @payment.total, user_id: @payment.user_id, vat: @payment.vat }
      assert_redirected_to payment_path(assigns(:payment))
    end

    test "should destroy payment" do
      assert_difference('Payment.count', -1) do
        delete :destroy, id: @payment
      end

      assert_redirected_to payments_path
    end
  end
end
