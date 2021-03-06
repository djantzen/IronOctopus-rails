class ApplicationController < ActionController::Base

  require Rails.root.to_s + '/lib/configuration'

  protect_from_forgery

  before_filter :set_last_seen
  before_filter :set_time_zone
  before_filter do
    @validations = IronOctopus::Configuration.instance.validations
    @application = IronOctopus::Configuration.instance.application
  end

  def set_last_seen
    if session[:last_seen].nil? or session[:last_seen] < Time.now - 60.minutes
      session[:last_seen] = Time.now
      # Create reporting.visit record (user_id, session_id, day_id, timestamp)
    end
  end

  def set_time_zone
    Time.zone = current_user.timezone.tzid if current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private
  
  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue Exception => rnf
      session[:user_id] = nil
    end
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

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end

  helper_method :mobile_device?
  helper_method :current_user
  helper_method :authenticate_user

end
