class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  def redirect_to_profile
    if current_user
      redirect_to(:controller => 'profile', :action => 'index')
      return false # halts the before_filter
    else    
      return true
    end
  end

  def redirect_to_login
    unless current_user
      redirect_to(:controller => 'login', :action => 'index')
      return false # halts the before_filter
    else
      return true
    end
  end

  def current_user
    if session[:user_id]
      User.find_by_email session[:user_id]
    end
  end
end
