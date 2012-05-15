class UsersController < ApplicationController

  respond_to :json, :html

  def new 
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.trainers << current_user
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render :new
    end
  end
  
  def index
#    @users = User.find(:all)
#    render :json => users
  end

  # GET /users/1.json
  def show
    @user = User.find(params['id'])
    @user.password_digest = nil
    @routines = @user.routines
    
    respond_with do |format|
      format.html { render :html => @user }
      format.json { render :json => @user.to_json }
    end
     
  end

  
end
