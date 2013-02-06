class ProfilesController < ApplicationController

  respond_to :html

  def show
    login = params[:user_id]
    @user = User.find_by_login(login)
    @profile = @user.profile
    redirect_to root_path unless @profile
  end

  def new
    login = params[:user_id]
    @user = User.find_by_login(login)
    unless @user.profile.nil?
      redirect_to root_path unless @profile
    end
    @profile = Profile.new
  end

  def create
    login = params[:user_id]
    @user = User.find_by_login(login)
    @profile = Profile.new(params[:profile])
    @profile.user = @user
    @profile.save
  end

  def edit
    login = params[:user_id]
    @user = User.find_by_login(login)
    @profile = @user.profile
    redirect_to root_path unless @profile
  end

  def update
    login = params[:user_id]
    @user = User.find_by_login(login)
    @profile = @user.profile
    @profile.creative = params[:profile][:creative]
    @profile.phone = params[:profile][:phone]
    @profile.email = params[:profile][:email]
    @profile.save
    #respond_with do |format|
    #  format.html { render :html => @profile }
    #end
  end


end
