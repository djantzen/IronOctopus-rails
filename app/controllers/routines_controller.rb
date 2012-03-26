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
                :repetitions => set.repetitions,
                :duration => set.measurement.duration,
                :pace => set.measurement.pace,
                :calories => set.measurement.calories,
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
  end

  def create
    wtf params
    @routine = normalize_routine(params[:routine])
    wtf @routine
    
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
          :repetitions => set.repetitions,
          :position => set.position,
          :duration => set.measurement.duration,
          :pace => set.measurement.pace,
          :calories => set.measurement.calories,
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
    routine.creator = current_user
    
    position = 0
    routine_hash[:activity_sets].each do |activity_set_hash|
      position += 1
      activity = Activity.find_by_name(activity_set_hash[:activity])      
      resistance_unit = Unit.find_by_name(activity_set_hash[:resistance_unit] || 'None')
      distance_unit = Unit.find_by_name(activity_set_hash[:distance_unit] || 'None')
      pace_unit = Unit.find_by_name(activity_set_hash[:pace_unit] || 'None')
      
      measurement_hash = {
        :resistance => activity_set_hash[:resistance],
        :distance => activity_set_hash[:distance],
        :pace => activity_set_hash[:pace],
        :calories => activity_set_hash[:calories],
        :distance_unit_id => distance_unit.unit_id,
        :pace_unit_id => pace_unit.unit_id,
        :resistance_unit_id => resistance_unit.unit_id
      }

      measurement = Measurement.find_or_create(measurement_hash)
      
      activity_set = ActivitySet.new
      activity_set.measurement = measurement
      activity_set.activity = activity
      activity_set.repetitions = activity_set_hash[:repetitions]
      activity_set.routine = routine
      activity_set.position = position
      
      routine.activity_sets << activity_set
    end
    
    routine
  end
  
end
