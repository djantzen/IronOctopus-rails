class ActivitiesController < ApplicationController
  
  respond_to :json, :html
  
  def index

    @activities = Activity.find(:all, :include => :activity_type)

    json_activities = @activities.map do |a|
      {
        :activity_key => a.name.to_identifier,
        :name => a.name,
        :activity_type => a.activity_type.name
      }
    end
    
    respond_with do |format|
      format.html { render :html => @activities }
      format.json { render :json => json_activities }
    end

  end

  def new
    @activity = Activity.new
    @body_parts = BodyPart.find(:all)
    @implements = Implement.find(:all)
    @activity_types = ActivityType.find(:all, :order => :name)
  end

  def create
    activity = create_or_update(params)
    activity.creator = current_user
    activity.save
    redirect_to(activity)
  end

  # GET /activities/1.json
  def show
    @activity = Activity.find(params[:id], :include => [:activity_type, :body_parts, :implements])
  end

  def edit
    @activity = Activity.find(params[:id])
    @body_parts = BodyPart.find(:all)
    @implements = Implement.find(:all)        
    @activity_types = ActivityType.find(:all)
  end
  
  def update
    activity = create_or_update(params)
    activity.save
    redirect_to(activity)
  end

  private
  def create_or_update(params)
    activity = params[:id] ? Activity.find(params[:id]) : Activity.new

    activity.body_parts.clear
    (params[:activity][:body_parts] || []).each do |formal_name|
      body_part = BodyPart.find_by_formal_name(formal_name)
      activity.body_parts << body_part unless activity.body_parts.include?(body_part)
    end

    activity.implements.clear
    (params[:activity][:implements] || []).each do |name|
      implement = Implement.find_by_name(name)
      activity.implements << implement unless activity.implements.include?(implement)
    end
    activity.name = params[:activity][:name]
    activity.instructions = params[:activity][:instructions]
    activity.activity_type = ActivityType.find(params[:activity][:activity_type])
    activity
  end
  
end
