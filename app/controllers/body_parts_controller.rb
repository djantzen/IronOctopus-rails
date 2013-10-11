class BodyPartsController < ApplicationController

  before_filter :authenticate_user

  def index
    authorize! :read, BodyPart.new, current_user
    @body_parts = BodyPart.order(:name).all
  end
  
  def new
    authorize! :read, BodyPart.new, current_user
    @body_part = BodyPart.new
  end
  
  def create
    authorize! :create, BodyPart.new, current_user
    @body_part = create_or_update(params)
    @body_part.creator = current_user
    @body_part.save
  end

  def edit
    @body_part = BodyPart.find_by_permalink(params[:id])
    authorize! :update, @body_part
  end
  
  def update
    @body_part = create_or_update(params)
    authorize! :update, @body_part
    @body_part.save
  end
  
  def show
    @body_part = BodyPart.find_by_permalink(params[:id])
    authorize! :read, @body_part
  end
  
  private
  def create_or_update(params)
    body_part = params[:id] ? BodyPart.find_by_permalink(params[:id]) : BodyPart.new
    params[:body_part][:region] = params[:body_part][:newregion] unless params[:body_part][:newregion].empty?
    params[:body_part].delete(:newregion)
    if Rails.env == "production" # In production, proxy the request. Can't in development because of single threaded webrick
      params[:body_part][:remote_image_url] = "#{view_context.proxied_pages_url}?url=#{params[:body_part][:remote_image_url]}"
    end
    body_part.assign_attributes(params[:body_part])
    body_part
  end

end
