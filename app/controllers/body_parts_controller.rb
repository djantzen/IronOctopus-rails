class BodyPartsController < ApplicationController

  before_filter :authenticate_user

  def index
    @body_parts = BodyPart.all
  end
  
  def new
    @body_part = BodyPart.new
  end
  
  def create
    body_part = create_or_update(params)
    body_part.creator = current_user
    body_part.save
    redirect_to(BodyPart)
  end

  def edit
    @body_part = BodyPart.find_by_permalink(params[:id])
  end
  
  def update
    body_part = create_or_update(params)
    body_part.save
    redirect_to(BodyPart)
  end
  
  def show
    @body_part = BodyPart.find_by_permalink(params[:id])
  end
  
  private
  def create_or_update(params)
    body_part = params[:id] ? BodyPart.find_by_permalink(params[:id]) : BodyPart.new
    params[:body_part][:region] = params[:body_part][:newregion] unless params[:body_part][:newregion].empty?
    params[:body_part].delete(:newregion)
    body_part.update_attributes(params[:body_part])
    body_part
  end

end
