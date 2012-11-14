class WelcomeController < ApplicationController
  
  def index
    unless current_user.nil?
      redirect_to user_path(current_user)
    end
  end

  def post_signup

  end

end
