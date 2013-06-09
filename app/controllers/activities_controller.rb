class ActivitiesController < ApplicationController
  
  respond_to :json, :html, :js
  before_filter :authenticate_user

  helper_method :allowed_to_update?

  def index
    @activities = Activity.order(:name).includes([:activity_type])

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
    new_or_edit
    allowed_to_create?
  end

  def create
    @activity = create_or_update(params)
    @activity.creator = current_user

    if @activity.save
      respond_with do |format|
        format.html { render :html => @activity }
      end
    else
      @entity = @activity
      respond_with do |format|
        format.html { render :html => @entity, :template => "shared/entity_errors" }
      end
    end
  end

  def show
    @activity = Activity.find_by_permalink(params[:id], :include => [:activity_type, :body_parts, :implements,
                                                                     :metrics, :activity_attributes, :activity_videos])
  end

  def edit
    @activity = Activity.find_by_permalink(params[:id])
    new_or_edit
    allowed_to_update?
  end
  
  def update
    @activity = create_or_update(params)

    if @activity.save
      respond_with do |format|
        format.html { render :html => @activity }
        format.json { render :json => @activity }
      end
    else
      @entity = @activity
      respond_with do |format|
        format.html { render :html => @entity, :template => "shared/entity_errors" }
      end
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
      activity.name = params[:activity][:name]
      activity.instructions = params[:activity][:instructions]
      activity.activity_type = ActivityType.find_by_name(params[:activity][:activity_type])
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
      activity.activity_videos.each do |activity_video|
        activity_video.delete
      end
      activity.activity_videos.clear
      (params[:activity][:activity_videos] || []).each do |video_uri|
        next unless valid_youtube_link?(video_uri)
        activity_video = ActivityVideo.new({:video_uri => video_uri})
        activity.activity_videos << activity_video unless activity.activity_videos.include?(activity_video)
      end
    end
    activity
  end

  def allowed_to_update?
    current_user.eql? @activity.creator
  end

  def allowed_to_create?
    !current_user.nil?
  end

  private
  def valid_youtube_link?(link)
    link.match(/^http:\/\/www\.youtube\.com\/watch\?v=\w+$/)
  end

  def new_or_edit()
    @body_parts = BodyPart.order(:region, :name)
    @implements = Implement.order(:category, :name)
    @metrics = Metric.list
    @activity_types = ActivityType.order(:name)
    @activity_attributes = ActivityAttribute.order(:name)
  end

end
