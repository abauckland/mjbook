require_dependency "mjbook/application_controller"

module Mjbook
  class InlinesController < ApplicationController
    before_action :set_inline, except: [:update]


    def new_line

      update_line_order(@line, 'new')
 
      @new_line = @line.dup
      @new_line.line_order = @line.line_order + 1
      @new_line.state = 'due'
      @new_line.save

      update_totals(@new_line.ingroup_id)

      respond_to do |format|
        format.js {render :new_line, :layout => false }
      end
    end


    def edit_line

      @linetypes = [['1','product item'],['2','service item (fixed price)'],['3','misc item']]

      respond_to do |format|
        format.js {render :edit_line, :layout => false }
      end
    end


    def update
      # changes format of line by inserting new line then delete old line
      @old_line = Inline.find(params[:id])
      @old_line_id = @old_line.id

      @line = Inline.create(:ingroup_id => @old_line.ingroup_id,
                            :line_order => @old_line.line_order,
                            :linetype => params[:inline][:linetype])

      @old_line.destroy
      update_totals(@line.ingroup_id)

      respond_to do |format|
        format.js {render :update_line, :layout => false }
      end
    end


    def delete_line

      @deleted_line_id = @line.id
      line_dup = @line.dup

      @line.destroy

      update_line_order(line_dup, 'delete')
      update_totals(line_dup.ingroup_id)

      respond_to do |format|
        format.js {render :delete_line, :layout => false }
      end 
    end


#differnt versions depending on linetype
    def update_cat
      
      if params[:value] == "Add new..."
        #render option for inputting new category
        respond_to do |format|
          format.js {render :change_cat_input, :layout => false }
        end
      else

        old_line = Inline.find(params[:id])
        @old_line_id = old_line.id 

        cat = Mjbook::Productcategory.where(:id => params[:value]).first

        @line = Inline.create(:cat => cat.text,
                             :ingroup_id => old_line.ingroup_id,
                             :line_order => old_line.line_order,
                             :linetype => old_line.linetype)

        old_line.destroy
        update_totals(@line.ingroup_id)

        respond_to do |format|
          format.js {render :update_line, :layout => false }
        end
      end
    end


    def update_item
      
      if params[:value] == "Add new..."
        #render option for inputting new category      
        respond_to do |format|
          format.js {render :update_product_new, :layout => false }
        end
      else

        old_line = Inline.find(params[:id])
        item = Product.where(:id => params[:value]).first
        cat = Productcategory.where(:id => item.productcategory_id).first

        if old_line.linetype == 1
        @line = Inline.create(:cat => cat.text,
                             :item => item.item,
                             :quantity => item.quantity,
                             :unit_id => item.unit_id,
                             :rate => item.rate,
                             :price => item.price, 
                             :vat_id => item.vat_id,
                             :vat_due => item.vat_due,
                             :total=> item.total,
                             :ingroup_id => old_line.ingroup_id,
                             :line_order => old_line.line_order,
                             :linetype => old_line.linetype)  
        end

        if old_line.linetype == 2
        @line = Inline.create(:cat => cat.text,
                             :item => item.item,
                             :quantity => 0,
                             :unit_id => item.unit_id,
                             :rate => 0,
                             :price => item.price, 
                             :vat_id => item.vat_id,
                             :vat_due => item.vat_due,
                             :total=> item.total,
                             :ingroup_id => old_line.ingroup_id,
                             :line_order => old_line.line_order,
                             :linetype => old_line.linetype)
        end

        if old_line.linetype == 3
        @line = Inline.create(:cat => cat.text,
                             :item => item.item,
                             :quantity => 0,
                             :unit_id => item.unit_id,
                             :rate => 0,
                             :price => 0, 
                             :vat_id => item.vat_id,
                             :vat_due => 0,
                             :total=> 0,     
                             :ingroup_id => old_line.ingroup_id,
                             :line_order => old_line.line_order,
                             :linetype => old_line.linetype)
        end
      
        @old_line_id = old_line.id 
        old_line.destroy

        update_totals(@line.ingroup_id)

        respond_to do |format|
          format.js {render :update_line, :layout => false }
        end
      end
    end

      
    def update_quantity

      clean_number(params[:value])

      price = (@line.rate*@value)
      vat_due = (@line.rate*@value*(@line.vat.rate/100))
      total = (@line.rate*@value)+(@line.rate*@value*(@line.vat.rate/100))

      @line.update(:quantity => @value, :price => price, :vat_due => vat_due, :total => total)

      update_totals(@line.ingroup_id)

      respond_to do |format|
        format.js {render :update_quantity, :layout => false }
      end
    end


    def update_rate

      clean_number(params[:value])

      price = (@line.quantity*@value)
      vat_due = (@line.quantity*@value*(@line.vat.rate/100))
      total = (@line.quantity*@value*(@line.vat.rate/100))+(@line.quantity*@value)

      @line.update(:rate => @value, :price => price, :vat_due => vat_due, :total => total)

      update_totals(@line.ingroup_id)

      respond_to do |format|
        format.js {render :update_rate, :layout => false }
      end
    end


    def update_vat_rate

      vat = Vat.where(:id => params[:value]).first 
      
      vat_due = (@line.rate*(vat.rate/100))
      total = (@line.rate + vat_due)*@line.quantity
      #update line, group and invoice totals
      @line.update(:total =>total, :vat_id => params[:value], :vat_due => vat_due)

      update_totals(@line.ingroup_id)

      respond_to do |format|
        format.js {render :update_vat_rate, :layout => false }
      end
    end

    def update_price
 
      clean_number(params[:value])

      vat_due = (@value/(1+@line.vat_rate.rate))*@line.vat_rate.rate 
      rate = @value-vat_due
      #update line, group and invoice totals
      @line.update(:price => @value, :vat_due => vat_due, :rate => rate)

      update_totals(@line.ingroup_id)

      render :update_line, :layout => false 
    end

    def update_total

#      clean_number(params[:value])

#      vat_due = (@value/(1+@line.vat_rate.rate))*@line.vat_rate.rate
#      rate = (@value-vat_due)/@line.quantity
#      price = @value-vat_due
      #update line, group and invoice totals
#      @line.update(:total => @value, :vat_due => vat_due, :rate => rate)

#      update_totals(@line.ingroup_id)

#      render :update_inline, :layout => false
    end

    def update_unit
      #save changes
      @line.update(:unit_id => params[:value])
      #render text only
      render :text=> @line.unit.text
    end

    def update_text
      #removes white space and punctuation from end of text
      clean_text(params[:value])
      #save changes
      @line.update(:text => @value)
      #render text only
      render :text=> params[:value]
    end



    private
      # Use callbacks to share common setup or constraints between actions.
      def set_inline
        @line = Inline.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def inline_params
        params.require(:inline).permit(:ingroup_id, :cat, :item, :quantity, :unit, :rate, :price, :vat_id, :vat_due, :total, :note, :linetype, :line_order, :state)
      end

      def update_totals(ingroup_id)
        #group subtotal
        vat_due = Inline.where(:ingroup_id => ingroup_id).sum(:vat_due)
        price = Inline.where(:ingroup_id => ingroup_id).sum(:price)
        total = Inline.where(:ingroup_id => ingroup_id).sum(:total)
        #update group subtotal
        @ingroup = Ingroup.where(:id => ingroup_id).first
        @ingroup.update(:vat_due => vat_due, :total => total, :price => price)

       #invoice totals
        group_ids = Ingroup.where(:invoice_id => @ingroup.invoice_id)
        price = Inline.where(:ingroup_id => group_ids).sum(:price)
        total = Inline.where(:ingroup_id => group_ids).sum(:total)
        vat_due = Inline.where(:ingroup_id => group_ids).sum(:vat_due)
        #update invoice
        @invoice = Invoice.where(:id => @ingroup.invoice_id).first
        @invoice.update(:vat_due => vat_due, :total => total, :price => price)

      end

      def update_line_order(selected_line, action) 
        subsequent_lines = Inline.where('ingroup_id = ? AND line_order > ?', selected_line.ingroup_id, selected_line.line_order)
        
        subsequent_lines.each_with_index do |line, i|
          if action == 'new'
            line.update(:line_order => selected_line.line_order + 2 + i)
          end
          if action == 'delete'
            line.update(:line_order => selected_line.line_order + i)
          end
        end
      end

  end
end
