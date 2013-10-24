class ActivityAttributesController < ApplicationController
  before_filter :authenticate_user

  def index
    authorize! :read, ActivityAttribute.new, current_user
    @activity_attributes = ActivityAttribute.order(:name).all
  end

  def show
    @activity_attribute = ActivityAttribute.find_by_permalink(params[:id])
    authorize! :read, @activity_attribute, current_user
  end

  def new
    authorize! :create, current_user
    @activity_attribute = ActivityAttribute.new
  end

  def create
    authorize! :create, current_user
    @activity_attribute = ActivityAttribute.create(params[:activity_attribute])
  end

  def edit
    authorize! :update, current_user
    @activity_attribute = ActivityAttribute.find_by_permalink(params[:id])
  end

  def update
    authorize! :update, current_user
    @activity_attribute = ActivityAttribute.find_by_permalink(params[:id])
    @activity_attribute.update_attributes(params[:activity_attribute])
  end

end
