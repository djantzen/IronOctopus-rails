class WorkController < ApplicationController

  before_filter :authenticate_user

  respond_to :json, :html
  include WorkHelper

  def index
    client = User.find_by_login(params[:user_id])
    @work = Work.where("user_id = #{client.user_id}")
                .order("start_time desc")
                .includes([:activity, :measurement, :routine, :start_day])
                .page(params[:page])
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
    client = User.find_by_login(params[:user_id])
    routine = client.routines.find_by_name(params[:routine][:routine])
    activity_sets.each do |activity_set_hash|
      begin
        activity = Activity.find_by_name(activity_set_hash[:activity])

        unit_hash = {
          :cadence_unit => Unit.lookup(activity_set_hash[:cadence_unit]),
          :distance_unit => Unit.lookup(activity_set_hash[:distance_unit]),
          :duration_unit => Unit.lookup(activity_set_hash[:duration_unit]),
          :speed_unit => Unit.lookup(activity_set_hash[:speed_unit]),
          :resistance_unit => Unit.lookup(activity_set_hash[:resistance_unit])
        }

        measurement_hash = {
          :calories => activity_set_hash[:calories].to_i,
          :cadence => activity_set_hash[:cadence].to_f,
          :distance => Unit.convert_to_meters(activity_set_hash[:distance].to_f, unit_hash[:distance_unit].name),
          :duration => Unit.convert_to_seconds(activity_set_hash[:duration], unit_hash[:duration_unit].name),
          :incline => activity_set_hash[:incline].to_f,
          :level => activity_set_hash[:level].to_i,
          :repetitions => activity_set_hash[:repetitions].to_i,
          :resistance => Unit.convert_to_kilograms(activity_set_hash[:resistance].to_f, unit_hash[:resistance_unit].name),
          :speed => Unit.convert_to_kilometers_per_hour(activity_set_hash[:speed].to_f, unit_hash[:speed_unit].name),
        }

        activity_set_hash[:start_time] ||= client.local_time
        activity_set_hash[:end_time] ||= activity_set_hash[:start_time]

        Work.transaction do
          measurement = Measurement.find_or_create(measurement_hash)
          unit_set = UnitSet.find_or_create(unit_hash)
          day = Day.find_or_create(activity_set_hash[:start_time].utc)

          work = Work.new(:user => client,
                          :activity => activity,
                          :measurement => measurement,
                          :routine => routine,
                          :unit_set => unit_set,
                          :start_time => activity_set_hash[:start_time],
                          :end_time => activity_set_hash[:end_time],
                          :start_day => day)
          work.save
        end

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
        unit_hash = {
          :cadence_unit => Unit.lookup(work_hash[:cadence_unit]),
          :distance_unit => Unit.lookup(work_hash[:distance_unit]),
          :duration_unit => Unit.lookup(work_hash[:duration_unit]),
          :speed_unit => Unit.lookup(work_hash[:speed_unit]),
          :resistance_unit => Unit.lookup(work_hash[:resistance_unit])
        }
        measurement_hash = {
          :calories => work_hash[:calories].to_i,
          :cadence => work_hash[:cadence].to_f,
          :distance => Unit.convert_to_meters(work_hash[:distance].to_f, unit_hash[:distance_unit].name),
          :duration => Unit.convert_to_seconds(work_hash[:duration].to_f, unit_hash[:duration_unit].name),
          :incline => work_hash[:incline].to_f,
          :level => work_hash[:level].to_i,
          :repetitions => work_hash[:repetitions].to_i,
          :resistance => Unit.convert_to_kilograms(work_hash[:resistance].to_f, unit_hash[:resistance_unit].name),
          :speed => Unit.convert_to_kilometers_per_hour(work_hash[:speed].to_f, unit_hash[:speed_unit].name),
        }
        measurement = Measurement.find_or_create(measurement_hash)
        unit_set = UnitSet.find_or_create(unit_hash)
        day = Day.find_or_create(work_hash[:start_time])

        work = Work.new(:user => user, :activity => activity, :measurement => measurement,
                        :routine => routine, :start_time => work_hash[:start_time], :end_time => work_hash[:end_time],
                        :start_day => day, :unit_set => unit_set)
        work.save
      rescue Exception => e
        puts e.inspect
      end
    end
  end

end
