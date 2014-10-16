require 'test_helper'

module Mjbook
  class InlinesControllerTest < ActionController::TestCase
    setup do
      @inline = inlines(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:inlines)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create inline" do
      assert_difference('Inline.count') do
        post :create, inline: { cat: @inline.cat, decimal: @inline.decimal, decimal: @inline.decimal, decimal: @inline.decimal, decimal: @inline.decimal, decimal: @inline.decimal, ingroup_id: @inline.ingroup_id, integer: @inline.integer, integer: @inline.integer, integer: @inline.integer, integer: @inline.integer, item: @inline.item, line_order: @inline.line_order, linetype: @inline.linetype, note: @inline.note, price: @inline.price, quantity: @inline.quantity, rate: @inline.rate, string: @inline.string, string: @inline.string, text: @inline.text, total: @inline.total, unit_id: @inline.unit_id, vat_due: @inline.vat_due, vat_id: @inline.vat_id }
      end

      assert_redirected_to inline_path(assigns(:inline))
    end

    test "should show inline" do
      get :show, id: @inline
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @inline
      assert_response :success
    end

    test "should update inline" do
      patch :update, id: @inline, inline: { cat: @inline.cat, decimal: @inline.decimal, decimal: @inline.decimal, decimal: @inline.decimal, decimal: @inline.decimal, decimal: @inline.decimal, ingroup_id: @inline.ingroup_id, integer: @inline.integer, integer: @inline.integer, integer: @inline.integer, integer: @inline.integer, item: @inline.item, line_order: @inline.line_order, linetype: @inline.linetype, note: @inline.note, price: @inline.price, quantity: @inline.quantity, rate: @inline.rate, string: @inline.string, string: @inline.string, text: @inline.text, total: @inline.total, unit_id: @inline.unit_id, vat_due: @inline.vat_due, vat_id: @inline.vat_id }
      assert_redirected_to inline_path(assigns(:inline))
    end

    test "should destroy inline" do
      assert_difference('Inline.count', -1) do
        delete :destroy, id: @inline
      end

      assert_redirected_to inlines_path
    end
  end
end
