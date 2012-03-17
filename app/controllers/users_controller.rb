class UsersController < ApplicationController

  def new 
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render :new
    end
  end
  
  def index
    users = User.find(:all)
    render :json => users
  end

  def login
    return "you did it!"
  end

  # GET /users/1.json
  def show
    puts "PARAMS #{params.inspect}"
    
    user = User.find(params['id'])
    user.password = nil
    render :json => user
  end

  
end
