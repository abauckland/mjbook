require_dependency "mjbook/application_controller"

module Mjbook
  class InvoicecontentsController < ApplicationController

    def show
      @invoice = policy_scope(Invoice).where(:id => params[:id]).first
      @ingroups = Mjbook::Ingroup.where(:invoice_id => @invoice.id)
    end

  end
end
