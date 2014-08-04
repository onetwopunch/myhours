class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  def redirect_to_profile
    if session[:user_id]
      redirect_to(:controller => 'profile', :action => 'index')
      return false # halts the before_filter
    else    
      return true
    end
  end

  def redirect_to_login
    unless session[:user_id]
      redirect_to(:controller => 'login', :action => 'index')
      return false # halts the before_filter
    else
      return true
    end
  end

end
