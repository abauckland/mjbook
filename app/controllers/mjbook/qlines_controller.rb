require_dependency "mjbook/application_controller"

module Mjbook
  class QlinesController < ApplicationController
    before_action :set_qline#, only: [:new_line, :change_line, :delete_line]


    def new_line
 
      @new_line = @line.dup
      @new_line.line_order = @line.line_order + 1
      @new_line.save

      update_line_order(@line, 'new')  
# TODO update_totals(qgroup_id)

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
      @new_line = Qline.create(:qgroup_id => @line.qgroup_id,
                               :line_order => @line.line_order,
                               :linetype => @line.linetype) 
      @line.destroy   
      
# TODO update_totals(@new_line.qgroup_id)
                
      respond_to do |format|
        format.js {render :update_line, :layout => false }  
      end      
    end


    def delete_line

      @deleted_line_id= @line.id      
      @line.destroy      

      update_line_order(@line, 'delete') 
# TODO update_totals(qgroup_id)
                   
      respond_to do |format|
        format.js {render :delete_line, :layout => false }  
      end          
    end


#differnt versions depending on linetype
    def update_cat
      
      if params[:value] == ""
        #render option for inputting new category
        render :update_cat_new, :layout => false        
        
      else  
        #delete old version of the line
        @line.destroy

        #set model names for each type of item, determined by linetype
        set_cat_item_model(@line)  
        
        #create new version of the line
        cat_model = model_name << "category"        
        catmodel = cat_model.to_sym
        cat = catmodel.where(:id => params[:value]).first        
        @line.create(:category => cat.name)        
        
        #replace existing line and replace with new based on selected category
        cat_item_options(@line)
        render :update_cat, :layout => false        
      end         
    end


    def update_item
      #populate all fields with product data
      if params[:value] == "{NEW ELEMENT}"
        #render option for inputting new category
        render :update_item_new, :layout => false        
        
      else 
        #set model names for each type of item, determined by linetype
        set_cat_item_model(@line)  
        
        #options for item select                 
        model = @model_name.to_sym
        cat_model = @model_name << "category"        
        catmodel = cat_model.to_sym      
        
        #get selected item
        item = model.where(:id => params[:value]).first
                
        #update all fields with data from item record        
        @line.update(:category => item.catmodel.name,
                      :item => item.item,
                      :quantity => item.quantity,
                      :rate => item.rate,
                      :unit_id => item.unit_id,
                      :vat_id => item.vat_id,
                      :vat_due => item.vat,
                      :price => item.price)
                               
        cat_options(@line)
        item_options(@line) 
        render :update_item, :layout => false        
      end  
    end

      
    def update_quantity

      clean_number(params[:value])
            
  #    vat_due = (@line.rate*@value*@line.vat_rate.rate)
      price = @value#(@line.rate.to_d*@value)#+(@line.rate*@value*@line.vat_rate.rate) 
      #update line, group and quote totals
      
      @line.update(:quantity => @value, :price => price)#, :vat_due => vat_due)            
     # update_totals(@line.qgroup_id)
    
 #    render :update_qline, :layout => false 
    end


    def update_rate

      clean_number(params[:value])
            
      vat_due = (@line.quantity*@value*vat_rate.rate)
      price = (@line.quantity*@value*vat_rate.rate)+(@line.quantity*@value)  
      #update line, group and quote totals
      
      @line.update(:rate => @value, :vat_due => vat_due, :price => price)            
      update_totals(@line.qgroup_id)
    
      render :update_qline, :layout => false 
    end

      
    def update_vat_rate

      vat_rate = Vat.where(:id => params[:value]).first 
      
      vat_due = (@line.price/(1+vat_rate.rate))*vat_rate.rate
      rate = @line.price - vat_due   
      #update line, group and quote totals
      @line.update(:rate => rate, :vat_id => params[:value], :vat_due => vat_due)            
      update_totals(@line.qgroup_id)
    
      render :update_qline, :layout => false 
    end


    def update_price
 
      clean_number(params[:value])
            
      vat_due = (@value/(1+@line.vat_rate.rate))*@line.vat_rate.rate 
      rate = @value-vat_due
      #update line, group and quote totals      
      @line.update(:price => @value, :vat_due => vat_due, :rate => rate)            
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
        params.require(:qline).permit(:qgroup_id, :cat, :item, :quantity, :unit, :rate, :vat_id, :vat_due, :price, :note, :linetype, :line_order)
      end

      
      def update_totals(qgroup_id)
        #group subtotal
        vat_due = Qline.sum(:vat_due).where(:qgroup_id => qgroup_id)
        price = Qline.sum(:price).where(:qgroup_id => qgroup_id)
        #update group subtotal
        @qgroup = Qgroup.where(:id => qgroup_id)
        @qgroup.update(:vat_due => vat_due,:price => price)
        
        #quote total
        vat_due = Qline.sum(:vat_due).joins(:qgroup).where('qgroup.quote_id' => @qgroup.quote_id)
        price = Qline.sum(:price).joins(:qgroup).where('qgroup.quote_id' => @qgroup.quote_id)
        #update quote total
        @quote = Quote.where(:id => @qgroup.quote_id)
        @quote.update(:vat_due => vat_due,:price => price)
        
        return @qgroup, @quote
            
      end

     
      def update_line_order(selected_line, action) 
        subsequent_lines = Qline.where('qgroup_id = ? AND line_order > ?', selected_line.qgroup_id, selected_line.line_order).order('line_order')
        
        subsequent_lines.each_with_index do |line, i|
          if action == 'new'
            line.update(:line_order => selected_line.line_order + 2 + i)
          end
          if action == 'delete'
            line.update(:line_order => selected_line.line_order + i)
          end
        end       
      end
      
      def set_cat_item_model(line)     
        
        case line.linetype
          when 1 ; @model_name = "Product"
          when 2 ; @model_name = "Service "         
          when 3 ; @model_name = "Rate"          
          when 4 ; @model_name = "Misc"
        end
        
        return @model_name  
      end
      
      def cat_item_options(line) 
        #set model names for each type of item and cat, determined by linetype
        set_cat_item_model(line)
                  
        model = model_name.to_sym
        cat_model = model_name << "category"        
        catmodel = cat_model.to_sym      

        #options for category and item select
        @category_options = catmodel..where(:company_id => current_user.company_id)
        @item_options = model.joins(catmodel).where('catmodel.name' => line.cat, :id => params[:value])
      end
      


  end
end
