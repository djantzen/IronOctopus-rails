class WorkController < ApplicationController

  before_filter :authenticate_user

  respond_to :json, :html
  include WorkHelper

  def index
    client = User.find_by_login(params[:user_id])
    @work = Work.where("user_id = #{client.user_id}")
                .order("start_time desc")
                .includes([:activity, :measurement, :routine, :day])
                .page(params[:page])

    @work_grouped_by_day_and_routine = Groupings.new
    current_routine = nil
    current_day = nil
    @work.each do |work|
      if current_day.nil? || current_day != work.day
        current_day = work.day and current_routine = nil
        @work_grouped_by_day_and_routine << RoutinesForDay.new(current_day)
      end
      if current_routine.nil? || current_routine != work.routine
        current_routine = work.routine
        @work_grouped_by_day_and_routine.current_grouping.add_routine(current_routine)
      end
      @work_grouped_by_day_and_routine.current_grouping.current_routine.add_work(work)
    end
    puts @work_grouped_by_day_and_routine
  end

  class Groupings < Array
    def current_grouping
      self[-1]
    end

    def to_s
      "#{self.size} groupings"
    end
  end

  class RoutinesForDay < Array
    attr_accessor :day

    def current_routine
      self[-1]
    end

    def initialize(day)
      @day = day
    end

    def add_routine(routine)
      self << WorkGroup.new(routine)
    end

    def to_s
      "#{self.size} routines performed on #{@day}"
    end
  end

  class WorkGroup < Array
    attr_accessor :routine

    def initialize(routine)
      @routine = routine
    end

    def add_work(work)
      self.unshift work
    end

    def to_s
      "#{self.size} activities performed on #{@day} from #{@routine.name}"
    end
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
    activity_sets.each do |activity_set_map|
      activity = Activity.find_by_name(activity_set_map[:activity])

      unit_map = Unit.activity_set_to_unit_map(activity_set_map)
      metric_map = Measurement.activity_set_to_metric_map(activity_set_map, unit_map)
      prescribed_metric_map = Measurement.activity_set_to_metric_map(activity_set_map[:prescribed], unit_map)

      activity_set_map[:start_time] ||= DateTime.now.utc

      Work.transaction do
        measurement = Measurement.find_or_create(metric_map)
        prescribed_measurement = Measurement.find_or_create(prescribed_metric_map)
        unit_set = UnitSet.find_or_create(unit_map)
        day = Day.find_or_create(activity_set_map[:start_time].utc)

        work = Work.new(:user => client,
                        :activity => activity,
                        :measurement => measurement,
                        :prescribed_measurement => prescribed_measurement,
                        :routine => routine,
                        :unit_set => unit_set,
                        :start_time => activity_set_map[:start_time].utc,
                        :day => day)
        work.save
      end
    end
  end

end
