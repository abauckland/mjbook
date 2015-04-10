module Mjbook
  class Mjbook::ApplicationController < ActionController::Base
   layout "mjbook/books"
   include Pundit
            
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
