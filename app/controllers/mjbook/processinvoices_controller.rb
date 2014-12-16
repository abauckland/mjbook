require_dependency "mjbook/application_controller"

module Mjbook
  class ProcessinvoicesController < ApplicationController    
    before_action :set_invoice, except: [:index]
    before_action :set_ingroups, except: [:index]
    before_action :set_inlines, except: [:index]
    before_action :set_invoice_price, except: [:index]
    before_action :set_invoice_vat_due, except: [:index]
    before_action :set_invoice_total, except: [:index] 
    before_action :set_accounts, except: [:index]
    before_action :set_paymethods, except: [:index]
        
    def index
      inline_ids = params[:checked_ids].split(",").map { |s| s.to_i }
      
      #group subtotal
      price = Inline.where(:id => inline_ids).sum(:price)
      vat_due = Inline.where(:id => inline_ids).sum(:vat_due)
      total = Inline.where(:id => inline_ids).sum(:total)
           
      render json: {:invoice_price => price, :invoice_vat_due => vat_due, :invoice_total => total, :inline_ids => inline_ids}
      
    end

    def payment
      @payment = Mjbook::Payment.new
    end

    def creditnote
      @creditnote = Mjbook::Creditnote.new
    end

    def writeoff
      @writeoff = Mjbook::Writeoff.new      
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_invoice
        @invoice = Mjbook::Invoice.where(:id => params[:id]).first
      end

      def set_ingroups
        @ingroups = Mjbook::Ingroup.includes(:inlines).where(:invoice_id => params[:id])
      end

      def set_inlines
        @inline_ids = Mjbook::Inline.due.where(:ingroup_id => @ingroups.ids).ids
      end

      def set_invoice_price
        @invoice_price = Mjbook::Inline.due.where(:ingroup_id => @ingroups.ids).sum(:price)
      end

      def set_invoice_vat_due
        @invoice_vat_due = Mjbook::Inline.due.where(:ingroup_id => @ingroups.ids).sum(:vat_due)
      end

      def set_invoice_total
        @invoice_total = Mjbook::Inline.due.where(:ingroup_id => @ingroups.ids).sum(:total)
      end

      def set_accounts
        @companyaccounts = policy_scope(Companyaccount)
      end
      
      def set_paymethods
        @paymethods = Mjbook::Paymethod.all        
      end

  end
end
