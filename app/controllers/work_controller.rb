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
    activity_sets.each do |activity_set_hash|
      begin
        activity = Activity.find_by_name(activity_set_hash[:activity])

        distance_unit = Unit.lookup(activity_set_hash[:distance_unit])
        duration_unit = Unit.lookup(activity_set_hash[:duration_unit])
        speed_unit = Unit.lookup(activity_set_hash[:speed_unit])
        resistance_unit = Unit.lookup(activity_set_hash[:resistance_unit])

        measurement_key = {
          :cadence => activity_set_hash[:cadence],
          :calories => activity_set_hash[:calories],
          :distance => Unit.convert_to_meters(activity_set_hash[:distance], distance_unit.name),
          :duration => Unit.convert_to_seconds(activity_set_hash[:duration], duration_unit.name),
          :incline => activity_set_hash[:incline],
          :level => activity_set_hash[:level],
          :resistance => Unit.convert_to_kilograms(activity_set_hash[:resistance], resistance_unit.name),
          :speed => Unit.convert_to_kilometers_per_hour(activity_set_hash[:speed], speed_unit.name)
        }
        activity_set_hash[:start_time] ||= Time.new
        activity_set_hash[:end_time] ||= activity_set_hash[:start_time]
        activity_set_hash[:repetitions] ||= 1

        measurement = Measurement.find_or_create(measurement_key)
        day = Day.find_or_create(activity_set_hash[:start_time])

        work = Work.new(:user => user, :activity => activity,
                        :measurement => measurement,
                        :repetitions => activity_set_hash[:repetitions],
                        :routine => routine, :start_time => activity_set_hash[:start_time],
                        :end_time => activity_set_hash[:end_time],
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
