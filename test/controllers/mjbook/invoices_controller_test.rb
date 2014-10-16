require 'test_helper'

module Mjbook
  class InvoicesControllerTest < ActionController::TestCase
    setup do
      @invoice = invoices(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:invoices)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create invoice" do
      assert_difference('Invoice.count') do
        post :create, invoice: { customer_ref: @invoice.customer_ref, date: @invoice.date, invoiceterms_id: @invoice.invoiceterms_id, invoicetype_id: @invoice.invoicetype_id, price: @invoice.price, project_id: @invoice.project_id, ref: @invoice.ref, status: @invoice.status, total: @invoice.total, vat_due: @invoice.vat_due }
      end

      assert_redirected_to invoice_path(assigns(:invoice))
    end

    test "should show invoice" do
      get :show, id: @invoice
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @invoice
      assert_response :success
    end

    test "should update invoice" do
      patch :update, id: @invoice, invoice: { customer_ref: @invoice.customer_ref, date: @invoice.date, invoiceterms_id: @invoice.invoiceterms_id, invoicetype_id: @invoice.invoicetype_id, price: @invoice.price, project_id: @invoice.project_id, ref: @invoice.ref, status: @invoice.status, total: @invoice.total, vat_due: @invoice.vat_due }
      assert_redirected_to invoice_path(assigns(:invoice))
    end

    test "should destroy invoice" do
      assert_difference('Invoice.count', -1) do
        delete :destroy, id: @invoice
      end

      assert_redirected_to invoices_path
    end
  end
end
