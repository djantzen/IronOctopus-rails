class WorkController < ApplicationController
  
  include LogUtils
  respond_to :json, :html

  def index
    @work = Work.all(:conditions => "user_id = #{current_user.user_id}",
                     :order => "start_time desc",
                     :include => [:activity, :measurement, :routine, :start_day])
  end

  def create

    if params[:_json]
      create_json(params)
    else
      create_html(params)
    end
    respond_with do |format|
      format.json { render :json => nil }
      format.html {  }
    end

  end

  def create_html(params)
    activity_sets = params[:routine][:activity_sets]
    user = User.find_by_login(params[:user_id])
    routine = user.routines.find_by_name(params[:routine][:routine])
    activity_sets.each do |activity_set|
      begin
        activity = Activity.find_by_name(activity_set[:activity])
        measurement_key = {
          :calories => activity_set[:calories],
          :distance => activity_set[:distance],
          :duration => activity_set[:duration],
          :incline => activity_set[:incline],
          :pace => activity_set[:pace],
          :resistance => activity_set[:resistance]
        }
        activity_set[:start_time] ||= Time.new
        activity_set[:end_time] ||= Time.new
        activity_set[:repetitions] ||= 1
        measurement = Measurement.find_or_create(measurement_key)
        day = Day.find_or_create(activity_set[:start_time])

        work = Work.new(:user => user, :activity => activity,
                        :measurement => measurement,
                        :repetitions => activity_set[:repetitions],
                        :routine => routine, :start_time => activity_set[:start_time],
                        :end_time => activity_set[:end_time],
                        :start_day => day)
        work.save
      rescue Exception => e
        puts e.inspect
      end
    end

  end

  def create_json(params)
    work_hashes = params[:_json]
    user = User.find_by_login(params[:user_id])
    work_hashes.each do |work_hash|
      begin
        activity = Activity.find_by_name(work_hash[:activity])
        routine = user.routines.find_by_name(work_hash[:routine])
        measurement_key = {
          :calories => work_hash[:calories],
          :distance => work_hash[:distance],
          :duration => work_hash[:duration],
          :incline => work_hash[:incline],
          :pace => work_hash[:pace],
          :resistance => work_hash[:resistance]
        }
        measurement = Measurement.find_or_create(measurement_key)
        day = Day.find_or_create(work_hash[:start_time])

        work = Work.new(:user => user, :activity => activity, :measurement => measurement,
                        :repetitions => work_hash[:repetitions] || 1,
                        :routine => routine, :start_time => work_hash[:start_time], :end_time => work_hash[:end_time],
                        :start_day => day)
        work.save
      rescue Exception => e
        puts e.inspect
      end
    end
  end


  def show
    wtf? params
  end
  
end
