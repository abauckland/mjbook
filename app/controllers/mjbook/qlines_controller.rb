require_dependency "mjbook/application_controller"

module Mjbook
  class QlinesController < ApplicationController
    before_action :set_qline, only: [:show, :edit, :update, :destroy]

    # GET /qlines
    def index
      @qlines = Qline.all
    end

    # GET /qlines/1
    def show
    end

    # GET /qlines/new
    def new
      @qline = Qline.new
    end

    # GET /qlines/1/edit
    def edit
    end

    # POST /qlines
    def create
      @qline = Qline.new(qline_params)

      if @qline.save
        redirect_to @qline, notice: 'Qline was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /qlines/1
    def update
      if @qline.update(qline_params)
        redirect_to @qline, notice: 'Qline was successfully updated.'
      else
        render :edit
      end
    end



    def update_text
      #removes white space and punctuation from end of text
      clean_text(params[:value])         
      #save changes
      @qline.update(:text => @value)     
      #render text only      
      render :text=> params[:value]          
    end
      
    def update_vat
      #removes white space and punctuation from end of text
      clean_number(params[:value])         
      #calculate updated values for line item
      vat = @value * @qline.vat.rate
      price = @value * @qline.rate
      #save change      
      @qline.update(:quantity => @value, :vat => vat, :price => price)
      #calculate changes to subtotal and total prices
      re_calculate_totals(@qline)           
##need to update other celss that display units     
      render :update_qline, :layout => false         
    end

    def update_rate
      #removes white space and punctuation from end of text
      clean_number(params[:value])         
      #calculate updated values for line item
      vat = @value * @qline.vat.rate
      price = @value * @qline.rate
      #save change      
      @qline.update(:quantity => @value, :vat => vat, :price => price)
      #calculate changes to subtotal and total prices
      re_calculate_totals(@qline)           
##need to update other celss that display units     
      render :update_qline, :layout => false         
    end      
      
    def update_unit
      #removes white space and punctuation from end of text
      clean_text(params[:value])         
      #save changes
      @qline.update(:unit => @value)     
##need to update other celss that display units     
      render :update_qline, :layout => false 
    end      
      
    def update_quantity
      #removes white space and punctuation from end of text
      clean_number(params[:value])         
      #calculate updated values for line item
      vat = @value * @qline.vat.rate
      price = @value * @qline.rate
      #save change      
      @qline.update(:quantity => @value, :vat => vat, :price => price)
      #calculate changes to subtotal and total prices
      re_calculate_totals(@qline)           
##need to update other celss that display units     
      render :update_qline, :layout => false      
    end 
         
    def update_item
      if params[:value] == ''
      #redraw line with text field
        render :change_product_input, :layout => false
      else  
      #process selected value
      
        render :update_qline, :layout => false
      end  
    end      
      
    def update_cat
      if params[:value] == ''
      #redraw line with text field
        render :change_cat_input, :layout => false
      else  
      #process selected value
      
        render :update_qline, :layout => false
      end       
    end




    # DELETE /qlines/1
    def destroy
      @qline.destroy
      redirect_to qlines_url, notice: 'Qline was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_qline
        @qline = Qline.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def qline_params
        params.require(:qline).permit(:qgroup_id, :cat, :item, :quantity, :unit, :rate, :vat_id, :vat, :price, :note, :linetype, :line_order)
      end
      
      def re_calculate_totals(qline)
       qline
      end 
            
      def clean_text(value)
        @value = value 
        @value.strip
        @value = @value.gsub(/\n/,"")
        @value.chomp
        @value.chomp   
        while [",", ";", "!", "?"].include?(value.last)
        @value.chop!
        end
      end

      def clean_number(value)
        @value = value 
        @value.strip
        @value = @value.gsub(/\n/,"")
        @value.chomp
        @value.chomp   
        while [".", ",", ";", "!", "?"].include?(value.last)
        @value.chop!
        end
      end

  end
end
