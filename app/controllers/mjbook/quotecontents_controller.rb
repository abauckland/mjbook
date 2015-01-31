require_dependency "mjbook/application_controller"

module Mjbook
  class QuotecontentsController < ApplicationController

    def show
      @quote = policy_scope(Quote).where(:id => params[:id]).first
      @qgroups = Mjbook::Qgroup.where(:quote_id => @quote.id)
    end

  end
end
