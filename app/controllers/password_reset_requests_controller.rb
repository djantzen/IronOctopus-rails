class PasswordResetRequestsController < ApplicationController

  def new
    @user = User.new
    @password_reset_request = PasswordResetRequest.new
  end

  def create
    @user = User.find_by_email(params[:password_reset_request][:email_to])
    if @user.nil?
      redirect_to :root
      return
    end
    PasswordResetRequest.transaction do
      mail = UserMailer.password_reset_request_email(@user, request)
      mail.deliver
    end
  end

  def edit
    @password_reset_request = PasswordResetRequest.find_by_password_reset_request_uuid(params[:id])
    @user = @password_reset_request.user
    if @password_reset_request.password_reset
      redirect_to :root
      return
    end
  end

  def update
    @password_reset_request = PasswordResetRequest.find(params[:id])
    @user = @password_reset_request.user
    reset_request = params[:password_reset_request]
    PasswordResetRequest.transaction do
      if !reset_request[:new_password].blank? && reset_request[:new_password].eql?(reset_request[:confirm_password])
        @password_reset_request.password_reset = true
        @password_reset_request.save
        @user.password = reset_request[:new_password]
        @user.save
        session[:user_id] = @user.user_id
        redirect_to :root, :notice => "Logged in!"
      else
        @user.errors.add(:password, "Password does not match confirmation")
        render :action => :edit
      end
    end
  end

end