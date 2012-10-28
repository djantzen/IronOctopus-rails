class ActivitiesController < ApplicationController
  
  respond_to :json, :html, :js
  before_filter :authenticate_user, :except => [:is_name_unique, :index]

  def index
    @activities = Activity.all(:include => :activity_type, :order => :name)

    json_activities = @activities.map do |a|
      {
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
    @body_parts = BodyPart.all
    @implements = Implement.all
    @metrics = Metric.all(:conditions => "name != 'None'")
    @activity_types = ActivityType.all(:order => :name)
    @activity_attributes = ActivityAttribute.all(:order => :name)
  end

  def create
    @activity = create_or_update(params)
    @activity.creator = current_user
    @activity.save
    respond_with do |format|
      format.js
      format.html { render :html => @activity }
    end
  end

  def show
    @activity = Activity.find_by_permalink(params[:id], :include => [:activity_type, :body_parts, :implements, :metrics, :activity_attributes])
  end

  def edit
    @activity = Activity.find_by_permalink(params[:id])
    @body_parts = BodyPart.all
    @implements = Implement.all
    @activity_types = ActivityType.all(:order => :name)
    @metrics = Metric.all(:conditions => "name != 'None'", :order => :name)
    @activity_attributes = ActivityAttribute.all(:order => :name)
  end
  
  def update
    @activity = create_or_update(params)
    @activity.save
    respond_with do |format|
      format.html { render :html => @activity, :template => "activities/show" }
      format.json { render :json => @activity }
    end
  end

  def is_name_unique
    activity_id = params[:activity_id]
    activity = Activity.first(:conditions => { :permalink => activity_id.to_identifier })
    respond_with do |format|
      format.json { render :json => activity.nil? }
    end
  end

  private
  def create_or_update(params)
    activity = params[:id] ? Activity.find_by_permalink(params[:id]) : Activity.new

    Activity.transaction do
      activity.body_parts.clear
      (params[:activity][:body_parts] || []).each do |name|
        body_part = BodyPart.find_by_name(name)
        activity.body_parts << body_part unless activity.body_parts.include?(body_part)
      end
      activity.implements.clear
      (params[:activity][:implements] || []).each do |name|
        implement = Implement.find_by_name(name)
        activity.implements << implement unless activity.implements.include?(implement)
      end
      activity.metrics.clear
      (params[:activity][:metrics] || []).each do |name|
        metric = Metric.find_by_name(name)
        activity.metrics << metric unless activity.metrics.include?(metric)
      end
      activity.activity_attributes.clear
      (params[:activity][:activity_attributes] || []).each do |name|
        attribute = ActivityAttribute.find_by_name(name)
        activity.activity_attributes << attribute unless activity.activity_attributes.include?(attribute)
      end
      activity.name = params[:activity][:name]
      activity.instructions = params[:activity][:instructions]
      activity.activity_type = ActivityType.find(params[:activity][:activity_type])
    end
    activity
  end

end
