require_dependency "mjbook/application_controller"

module Mjbook
  class QuotecontentsController < ApplicationController
    before_action :set_quote, only: [:show]

    def show
      @qgroups = Qgroup.where(:quote_id => params[:id])
    end
    

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_quote
        @quote = policy_scope(Quote).where(:id => params[:id]).first
      end

  end
end
