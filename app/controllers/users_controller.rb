class UsersController < ApplicationController
  
  def index
    users = User.find(:all)
    render :json => users
  end

  def create

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
