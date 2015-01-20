require_dependency "mjbook/application_controller"

module Mjbook
  class WriteoffsController < ApplicationController
    before_action :set_writeoff, only: [:show, :destroy]

    # GET /writeoffs
    def index

          if params[:date_from] != ""
            if params[:date_to] != ""
              @writeoffs = policy_scope(Writeoff).where(:date => params[:date_from]..params[:date_to])
            else
              @writeoffs = policy_scope(Writeoff).where('date > ?', params[:date_from])
            end
          else
            if params[:date_to] != ""
              @writeoffs = policy_scope(Writeoff).where('date < ?', params[:date_to])
            else
              @writeoffs = policy_scope(Writeoff)
            end
          end

          if params[:commit] == 'pdf'
            pdf_writeoff_index(writeoffs, params[:customer_id], params[:date_from], params[:date_to])
          end

       @sum_price = @writeoffs.pluck(:price).sum
       @sum_vat = @writeoffs.pluck(:vat).sum
       @sum_total = @writeoffs.pluck(:total).sum

       @date_from = params[:date_from]
       @date_to = params[:date_to]

      authorize @writeoffs
    end

    # GET /writeoffs/1
    def show
      authorize @writeoff
    end

    # POST /writeoffs
    def create
      @writeoff = Writeoff.new(writeoff_params)
      authorize @writeoff
      if @writeoff.save
        redirect_to @writeoff, notice: 'Writeoff was successfully created.'
      else
        render :new
      end
    end

    def create
      @writeoff = Writeoff.new(writeoff_params)
      authorize @writeoff
      if @writeoff.save

        inlines = Mjbook::Inline.where(:id => params[:line_ids].to_a)
        invoice = Mjbook::Invoice.where(:id => params[:invoice_id]).first
                  
        inlines.each do |item|
          Mjbook::Writeoffitem.create(:writeoff_id => @writeoff.id, :inline_id => item.id)
          item.pay!
        end

        #check if all the inlines for the invoice have been paid          
        check_inlines = Mjbook::Inline.paid.join(:ingroup).where('mjbooks_invoice_id' => invoice.id)
        if check_inlines.blank?
          invoice.pay!
        else  
          invoice.part_pay!
        end     
        
        redirect_to writeoffs_path, notice: 'Write off was successfully record.'
      else
        redirect_to new_paymentscope_path(:invoice_id => params[:invoice_id])
      end
    end


    # DELETE /writeoffs/1
    def destroy
      authorize @writeoff
      @writeoff.destroy

        invoice = Mjbook::Invoice.where(:id => writeoff.invoice_id).first
        check_inlines = Mjbook::Inline.paid.join(:ingroup).where(:invoice_id => invoice.id)
        if check_inlines.blank?
          invoice.correct_payment!
        else
          invoice.correct_part_payment!
        end

      redirect_to writeoffs_url, notice: 'Writeoff was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_writeoff
        @writeoff = Writeoff.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def writeoff_params
        params.require(:writeoff).permit(:company_id, :ref, :price, :vat, :total, :date, :notes)
      end
  end
end
