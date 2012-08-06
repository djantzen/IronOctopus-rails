class UsersController < ApplicationController

  respond_to :html
#  before_filter :authenticate_user

  def new 
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    #    @user.trainers << current_user ? current_user : @user
    if @user.save
      session[:user_id] = @user.user_id
      redirect_to root_url, :notice => "Signed up!"
    else
      render :new
    end
  end

  def clients
    @clients = current_user.clients
  end

  def index
#    @users = User.all
#    render :json => users
  end

  # GET /users/1.json
  def show
    @user = User.find_by_login(params['id'])
    @user.password_digest = nil
    @routines = @user.routines
    
    respond_with do |format|
      format.html { render :html => @user }
    end
     
  end

  
end
