module Mjbook
  class ApplicationController < ActionController::Base
    
      layout "mjbook/books"
 
   def current_user
    @current_user = User.first    
  end
  
  helper_method :current_user

            
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
        @value = @value.to_d
      end


    
  end
end
