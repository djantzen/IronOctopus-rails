class ActivitiesController < ApplicationController
  
  respond_to :json, :html, :js
  before_filter :authenticate_user

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
  end

  def create
    @activity = create_or_update(params)

    if @activity.errors.empty?
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
    authorize! :update, @activity
    new_or_edit
  end
  
  def update
    @activity = create_or_update(params)
    authorize! :update, @activity

    if @activity.errors.empty?
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
    rename_images_dir = (activity.name != "" and activity.name != params[:activity][:name]) ? true : false
    original_activity_image_dir = activity.activity_images.size > 0 ? "public/" + activity.activity_images.first.image.store_dir : ""
    new_activity_image_dir = original_activity_image_dir.gsub(activity.name.to_identifier, params[:activity][:name].to_identifier)
    # if name changed, we have to rename image directory, if it exists.
    if rename_images_dir and File.exists?(original_activity_image_dir)
      `mv #{original_activity_image_dir} #{new_activity_image_dir}`
    end

    Activity.transaction do
      activity.name = params[:activity][:name]
      activity.creator = current_user
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
      (params[:activity][:activity_images_attributes] || {}).values.each do |hash|
        image = hash[:image]
        remote_image_url = hash[:remote_image_url]
        if !image.blank?
          activity_image = activity.activity_images.find_by_image(image)
          if hash[:remove_image] == "1" # delete manually since carrier-wave just wants to set it to the empty string
            activity_image.delete
          else
            activity_image.assign_attributes(hash)
            activity_image.save
          end
        elsif !remote_image_url.blank?
          if Rails.env == "production" # In production, proxy the request. Reroute in development because of single threaded webrick
            hash[:remote_image_url] = "#{view_context.proxied_pages_url}?url=#{remote_image_url}"
          else
            hash[:remote_image_url] = "http://localhost:3001/admin/proxied_pages?url=#{remote_image_url}"
          end
          activity_image = ActivityImage.new
          activity_image.activity = activity
          activity_image.assign_attributes(hash)
          activity.activity_images << activity_image
          activity_image.activity_image_origin = ActivityImageOrigin.new(:activity_image => activity_image,
                                                                         :origin_url => remote_image_url)
        end
      end
      (params[:activity][:activity_citations_attributes] || {}).values.each do |hash|
        unless hash[:citation_url].blank?
          activity_citation = activity.activity_citations.find_by_citation_url(hash[:citation_url])
          if activity_citation.nil?
            activity_citation = ActivityCitation.new(:citation_url => hash[:citation_url])
            activity.activity_citations << activity_citation
          end
        end
      end
      activity.alternate_activity_names.each {|name| name.delete}
      (params[:activity][:alternate_activity_names_attributes] || {}).values.each do |hash|
        unless hash[:name].blank?
          alternate_activity_name = AlternateActivityName.new(:name => hash[:name])
          activity.alternate_activity_names << alternate_activity_name
        end
      end
      activity.save
      # rollback directory rename if we didn't save properly
      if !activity.errors.empty? and rename_images_dir and File.exists?(new_activity_image_dir)
        `mv #{new_activity_image_dir} #{original_activity_image_dir}`
      end
    end

    activity
  end

  private
  def valid_youtube_link?(link)
    link.match(/^http:\/\/www\.youtube\.com\/watch\?/)
  end

  def new_or_edit
    @body_parts = BodyPart.order(:region, :name)
    @implements = Implement.order(:category, :name)
    @metrics = Metric.list
    @activity_types = ActivityType.order(:name)
    @activity_attributes = ActivityAttribute.order(:name)
    4.times { @activity.activity_images.build }
    4.times { @activity.activity_citations.build }
    2.times { @activity.alternate_activity_names.build }
  end

end
