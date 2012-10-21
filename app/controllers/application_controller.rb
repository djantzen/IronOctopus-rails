class ApplicationController < ActionController::Base

  require 'lib/configuration'

  protect_from_forgery

  before_filter :set_time_zone

  def set_time_zone
    Time.zone = current_user.time_zone if current_user
  end

  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user
    unless session[:user_id]
      redirect_to(:controller => 'sessions', :action => 'new')
      return false
    else
      # set current user object to @current_user object variable
      @current_user = User.find session[:user_id]
      return true
    end
  end

  helper_method :current_user
  helper_method :authenticate_user

end
