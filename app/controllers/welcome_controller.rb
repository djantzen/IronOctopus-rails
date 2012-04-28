class WelcomeController < ApplicationController
  
  def index
    if session[:user_id].nil?
      redirect_to '/sessions/new', :action => :index
    else
      redirect_to :site
    end
  end
  
end
