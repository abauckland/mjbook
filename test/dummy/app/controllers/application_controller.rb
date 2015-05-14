class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  include Pundit
  protect_from_forgery with: :exception
  
  def current_user
    @current_user = User.first    
  end
  
  helper_method :current_user

  # Globally rescue Authorization Errors in controller.
  # Returning 403 Forbidden if permission is denied  
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied
 
  private
 
  def permission_denied
    head 403
  end


  
end
