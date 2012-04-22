class ImplementsController < ApplicationController
  
  def index
    @implements = Implement.find(:all)
  end
  
  def new
    @implement = Implement.new
  end
  
  def create
    implement = create_or_update(params)
    implement.creator = current_user
    implement.save
    redirect_to(implement)
  end

  def edit
    @implement = Implement.find(params[:id])
  end
  
  def update
    implement = create_or_update(params)
    implement.save
    redirect_to(implement)
  end
  
  def show
    @implement = Implement.find(params[:id])
  end
  
  private
  def create_or_update(params)
    implement = params[:id] ? Implement.find(params[:id]) : Implement.new

    implement.name = params[:implement][:name]
    implement
  end

end
