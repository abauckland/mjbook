module Mjbook
  class ApplicationController < ActionController::Base
    
      layout "mjbook/books"
 
   def current_user
    @current_user = User.first    
  end
  
  helper_method :current_user
    
  end
end
