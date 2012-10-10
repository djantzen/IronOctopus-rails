class SessionsController < ApplicationController

  def new
  end

  def confirm
    uuid = params[:confirmation_token]
    Confirmation.transaction do
      confirmation = Confirmation.find_by_confirmation_uuid(uuid)
      confirmation.confirmed = true
      confirmation.save
      confirmation.user.identity_confirmed = true
      confirmation.user.save
      session[:user_id] = confirmation.user.user_id
      redirect_to root_url, :notice => "Logged in!"
    end
  end

  def create
    user = User.find_by_login(params[:login])
    if user && user.authenticate(params[:password]) && user.identity_confirmed
      session[:user_id] = user.user_id
      redirect_to user_path(user), :notice => "Logged in!"
    else
      flash.now.alert = "Invalid login or password, or you have not yet confirmed your email address"
      render :new
    end
    
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end
