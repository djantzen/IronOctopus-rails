class ImplementsController < ApplicationController

  before_filter :authenticate_user, :except => [:is_name_unique, :index]
  respond_to :json, :html

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
    @implement = Implement.find_by_permalink(params[:id])
  end
  
  def update
    implement = create_or_update(params)
    implement.save
    redirect_to(implement)
  end
  
  def show
    @implement = Implement.find_by_permalink(params[:id])
  end

  def is_name_unique
    implement_id = params[:implement_id]
    implement = Implement.first(:conditions => { :permalink => implement_id.to_identifier })
    respond_with do |format|
      format.json { render :json => implement.nil? }
    end
  end

  private
  def create_or_update(params)
    implement = params[:id] ? Implement.find(params[:id]) : Implement.new

    implement.name = params[:implement][:name]
    implement.category = params[:implement][:category]
    implement
  end

end
