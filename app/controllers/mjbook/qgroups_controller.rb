require_dependency "mjbook/application_controller"

module Mjbook
  class QgroupsController < ApplicationController
    before_action :set_qgroup

    def new_group
      
      update_group_order(@group, 'new')
  
      @new_group = @group.dup
      @new_group.group_order = @group.group_order + 1
      @new_group.save

      respond_to do |format|
        format.js {render :new_group, :layout => false }  
      end 
    end


    def delete_group

      @line_ids = Qline.where(:qgroup_id => @group.id).pluck(:id)

      @deleted_group_id = @group.id
      group_dup = @group.dup 
         
      @group.destroy
      
      update_group_order(group_dup, 'delete') 
      update_totals(group_dup.quote_id)
      
      respond_to do |format|
        format.js {render :delete_group, :layout => false }  
      end       
    end
    
    
    def update_text
      #removes white space and punctuation from end of text
      clean_text(params[:value])         
      #save changes
      @group.update(:text => @value)     
      #render text only      
      render :text=> params[:value]          
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_qgroup
        @group = Qgroup.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def qgroup_params
        params.require(:qgroup).permit(:quote_id, :ref, :text, :price, :vat_due, :total, :group_order)
      end


      def update_group_order(selected_group, action) 
        subsequent_groups = Qgroup.where('quote_id = ? AND group_order > ?', selected_group.quote_id, selected_group.group_order).order('group_order')
        
        @subsequent_prefix = []
        
        subsequent_groups.each_with_index do |group, i|
          if action == 'new'
            group.update(:group_order => selected_group.group_order + 2 + i)
            @subsequent_prefix[i] = [group.id, selected_group.group_order + 2 + i]
          end
          if action == 'delete'
            group.update(:group_order => selected_group.group_order + i)
            @subsequent_prefix[i] = [group.id, selected_group.group_order + i]
          end
        end
        @subsequent_prefix.compact!       
      end

 
      def update_totals(quote_id)        
        @quote = Quote.where(:id => quote_id).first
       #quote totals           
        price = Qline.joins(:qgroup).where('mjbook_qgroups.quote_id' => quote_id).sum(:price)
        total = Qline.joins(:qgroup).where('mjbook_qgroups.quote_id' => quote_id).sum(:total)
        vat_due = Qline.joins(:qgroup).where('mjbook_qgroups.quote_id' => quote_id).sum(:vat_due)
        #update quote        
        @quote.update(:vat_due => vat_due, :total => total, :price => price)                   
      end  

  end
end
