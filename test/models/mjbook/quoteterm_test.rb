require 'test_helper'

module Mjbook
  class QuotetermTest < ActiveSupport::TestCase

    setup do
      @quoteterm = quoteterms(:thirty_days)
    end

#vaildations
   test "should not save project without ref" do
      quoteterm = Quoteterm.create( :terms => @quoteterm.terms, :period => @quoteterm.terms, :company_id => @quoteterm.company_id)
      assert_not quoteterm.valid?, 'Should not create terms without ref', quoteterm.errors.messages[:ref]
   end

   test "should not save project without terms" do
      quoteterm = Quoteterm.create( :ref => @quoteterm.ref, :period => @quoteterm.terms, :company_id => @quoteterm.company_id)
      assert_not quoteterm.valid?, 'Should not create terms without ref', quoteterm.errors.messages[:terms]
   end

   test "should not save project without period" do
      quoteterm = Quoteterm.create( :ref => @quoteterm.ref, :terms => @quoteterm.terms, :company_id => @quoteterm.company_id)
      assert_not quoteterm.valid?, 'Should not create terms without period', quoteterm.errors.messages[:period]
   end

   test "should not save project if period not numerical" do
      quoteterm = Quoteterm.create( :ref => @quoteterm.ref, :terms => @quoteterm.terms, :period => "test", :company_id => @quoteterm.company_id)
      assert_not quoteterm.valid?, 'Should not create terms if period not numerical', quoteterm.errors.messages[:period]
   end

   test "should save terms" do
      quoteterm = Quoteterm.create( :ref => @quoteterm.ref, :terms => @quoteterm.terms, :period => @quoteterm.terms, :company_id => @quoteterm.company_id)
      assert_not quoteterm.valid?, 'Should not create terms'
   end

  end
end
