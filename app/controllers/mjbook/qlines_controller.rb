require_dependency "mjbook/application_controller"

module Mjbook
  class QlinesController < ApplicationController
    before_action :set_qline, except: [:update]


    def new_line

      update_line_order(@line, 'new')  
 
      @new_line = @line.dup
      @new_line.line_order = @line.line_order + 1
      @new_line.save

      update_totals(@new_line.qgroup_id)

      respond_to do |format|
        format.js {render :new_line, :layout => false }
      end      
    end


    def edit_line
      
      @linetypes = [['1','product item'],['2','service item (fixed price)'],['3','service item (hourly rate)'],['4','misc item']]
      
      respond_to do |format|
        format.js {render :edit_line, :layout => false }  
      end            
    end


    def update
      # changes format of line by inserting new line then delete old line 
      @old_line = Qline.find(params[:id])     
     
      @line = Qline.create(:qgroup_id => @old_line.qgroup_id,
                               :line_order => @old_line.line_order,
                               :linetype => params[:qline][:linetype]) 

      @old_line_id = @old_line.id      
      @old_line.destroy   
      
      update_totals(@line.qgroup_id)
                
      respond_to do |format|
        format.js {render :update_line, :layout => false }  
      end      
    end


    def delete_line

      @deleted_line_id = @line.id
      deleted_line_group_id = @line.qgroup_id      
      @line.destroy      
# TODO this does not work - line ahs been deleted
      update_line_order(@line, 'delete') 

      update_totals(deleted_line_group_id)
                   
      respond_to do |format|
        format.js {render :delete_line, :layout => false }  
      end          
    end


#differnt versions depending on linetype
    def update_cat
      
      if params[:value] == "Add new..."
        #render option for inputting new category      
        respond_to do |format|      
          format.js {render :update_cat_new, :layout => false }        
        end        
      else  
        #set model names for each type of item, determined by linetype
        #case line.linetype
        #  when 1 ; @model_name = "Product"
        #  when 2 ; @model_name = "Service "         
        #  when 3 ; @model_name = "Rate"          
        #  when 4 ; @model_name = "Misc"
        #end
        old_line = Qline.find(params[:id])
        @model_name = "Productcategory"
        
        const_name =  @model_name.camelize
        category_klass = Mjbook.const_get(const_name)
        cat = category_klass.where(:id => params[:value]).first        
        
        @line = Qline.create(:cat => cat.text,
                             :qgroup_id => old_line.qgroup_id,
                             :line_order => old_line.line_order,
                             :linetype => old_line.linetype)        

        @old_line_id = old_line.id 
        old_line.destroy

        update_totals(@line.qgroup_id)

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
        #set model names for each type of item, determined by linetype
        #case line.linetype
        #  when 1 ; @model_name = "Product"
        #  when 2 ; @model_name = "Service "         
        #  when 3 ; @model_name = "Rate"          
        #  when 4 ; @model_name = "Misc"
        #end
        old_line = Qline.find(params[:id])
        @model_name = "Product"
        
        const_name =  @model_name.camelize
        item_klass = Mjbook.const_get(const_name)
        item = item_klass.where(:id => params[:value]).first        
        
        cat = Productcategory.where(:id => item.productcategory_id).first
        
        @line = Qline.create(:cat => cat.text,
                             :item => item.item,
                             :quantity => item.quantity,
                             :unit_id => item.unit_id,
                             :rate => item.rate,
                             :price => item.price, 
                             :vat_id => item.vat_id,
                             :vat_due => item.vat_due,
                             :total=> item.price,     
                             :qgroup_id => old_line.qgroup_id,
                             :line_order => old_line.line_order,
                             :linetype => old_line.linetype)        

        @old_line_id = old_line.id 
        old_line.destroy

        update_totals(@line.qgroup_id)

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

      update_totals(@line.qgroup_id)
      
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
      
      update_totals(@line.qgroup_id)
      
      respond_to do |format|      
        format.js {render :update_rate, :layout => false }        
      end
    end

      
    def update_vat_rate

      vat = Vat.where(:id => params[:value]).first 
      
      vat_due = (@line.rate*(vat.rate/100))
      total = (@line.rate + vat_due)*@line.quantity   
      #update line, group and quote totals
      @line.update(:total =>total, :vat_id => params[:value], :vat_due => vat_due)            
      
      update_totals(@line.qgroup_id)
    
      respond_to do |format|      
        format.js {render :update_vat_rate, :layout => false }        
      end
    end

    def update_price
 
#      clean_number(params[:value])
            
#      vat_due = (@value/(1+@line.vat_rate.rate))*@line.vat_rate.rate 
#      rate = @value-vat_due
#      #update line, group and quote totals      
#      @line.update(:price => @value, :vat_due => vat_due, :rate => rate)            
      
#      update_totals(@line.qgroup_id)
    
#      render :update_qline, :layout => false 
    end

    def update_total
 
      clean_number(params[:value])
            
      vat_due = (@value/(1+@line.vat_rate.rate))*@line.vat_rate.rate 
      rate = (@value-vat_due)/@line.quantity
      price = @value-vat_due
      #update line, group and quote totals      
      @line.update(:total => @value, :vat_due => vat_due, :rate => rate)            
      
      update_totals(@line.qgroup_id)
    
      render :update_qline, :layout => false 
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
      def set_qline
        @line = Qline.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def qline_params
        params.require(:qline).permit(:qgroup_id, :cat, :item, :quantity, :unit, :rate, :price, :vat_id, :vat_due, :total, :note, :linetype, :line_order)
      end

      def update_totals(qgroup_id)
        #group subtotal
        vat_due = Qline.where(:qgroup_id => qgroup_id).sum(:vat_due)
        price = Qline.where(:qgroup_id => qgroup_id).sum(:price)
        #update group subtotal
        @qgroup = Qgroup.where(:id => qgroup_id).first
        @qgroup.update(:sub_vat => vat_due, :sub_price => price)

       #quote totals              
        group_ids = Qgroup.where(:quote_id => @qgroup.quote_id)
        total_price = Qline.where(:qgroup_id => group_ids).sum(:price)
        total_vat = Qline.where(:qgroup_id => group_ids).sum(:vat_due)
        #update quote
        @quote = Quote.where(:id => @qgroup.quote_id).first
        @quote.update(:total_vat => total_vat, :total_price => total_price)
                   
      end      
     
      def update_line_order(selected_line, action) 
        subsequent_lines = Qline.where('qgroup_id = ? AND line_order > ?', selected_line.qgroup_id, selected_line.line_order)
        
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
