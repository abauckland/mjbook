class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception
#  before_action :authenticate_user!
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  #after_action :verify_authorized, unless: :devise_controller?
  #after_action :verify_policy_scoped, :only => :index

  # Globally rescue Authorization Errors in controller.
  # Returning 403 Forbidden if permission is denied  
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  layout :layout_by_resource


  #root to admin index page after successfull sign in
  def after_sign_in_path_for(resource)
    dashboards_path
  end

 
  private
 
  def permission_denied
    head 403
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :surname, :email, :password, :password_confirmation, :first_name, :surname, :role, :company_id, :company_attributes => [:name, :subdomain, :domain]) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :surname, :email, :password, :password_confirmation, :current_password, :first_name, :surname, :role, :company_id, :company_attributes => [:name]) }

  end

  def layout_by_resource
    if controller_name == 'sessions' && action_name == 'new'
      'devise'
    else
      'application'
    end
  end



end