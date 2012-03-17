class RoutinesController < ApplicationController
  include StringUtils
  include LogUtils

  def index
    user = User.find_by_login(params['user_id'])
    
    if user.nil?
        raise "Wrong user dude"
    end
    
    routines = user.routines

    if routines.nil?
        raise "No routines dude"
    end
    
    denorm_routines = routines.map do |routine|
        next if routine.activity_sets.nil?
        {
            :routine_id => user.login + '_' + as_identifier(routine.name),
            :name => routine.name,
            :goal => routine.goal,
            :owner => routine.owner.login,
            :creator => routine.creator.login,
            :activity_sets => routine.activity_sets.map do |set|
            {
                :activity => set.activity.name,
                :position => set.position,
                :duration => set.measurement.duration,
                :pace => set.measurement.pace,
                :calories => set.measurement.calories,
                :repetitions => set.measurement.repetitions,
                :resistance => set.measurement.resistance,
                :distance_unit => set.measurement.distance_unit.name,
                :pace_unit => set.measurement.pace_unit.name,
                :resistance_unit => set.measurement.resistance_unit.name
            }
            end
        }
    end
    
    render :json => denorm_routines
  end
    
  def new
    @routine = Routine.new
    puts "PARAMS FOR NEW #{params.inspect}"
  end

  def create
    puts "PARAMS " + params.inspect
    @routine = Routine.new(params[:routine])
    @routine.creator = current_user
    @routine.owner = current_user
    @routine.save

#    render :json => activity
  end

  # GET /activities/1.json
  def show
    routines = Routine.find(params[:id])
    
    render :json => routines
  end


  def denormalize_routine(routine)
    {
      :name => routine.name,
      :goal => routine.goal,
      :owner => routine.owner.login,
      :creator => routine.creator.login,
      :activity_sets => routine.activity_sets.map do |set|
      {
          :activity => set.activity.name,
          :position => set.position,
          :duration => set.measurement.duration,
          :pace => set.measurement.pace,
          :calories => set.measurement.calories,
          :repetitions => set.measurement.repetitions,
          :resistance => set.measurement.resistance,
          :distance_unit => set.measurement.distance_unit.name,
          :pace_unit => set.measurement.pace_unit.name,
          :resistance_unit => set.measurement.resistance_unit.name
      }
      end
    }
  end

  def normalize_routine(routine_hash)
    routine = Routine.new
    routine.name = routine_hash[:name]
    routine.goal = routine_hash[:goal]
    routine.owner = User.find_by_login(routine_hash[:owner])
    routine.creator = User.find_by_login(routine_hash[:creator])
    routine_hash[:activity_sets].each do |activity_set_hash|
      activity_set = ActivitySet.new
      wtf activity_set_hash.inspect
      activity = Activity.find_by_name(activity_set_hash[:activity])
      wtf activity
      measurement_hash = activity_set_hash
      measurement_hash.delete(:activity)
      measurement = Measurement.find_or_create(measurement_hash)
      wtf measurement
      activity_set.measurement = measurement
      activity_set.activity = activity
      activity_set.routine = routine
    end
    
    wtf routine
  end
  
end
