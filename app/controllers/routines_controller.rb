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
            :trainer => routine.trainer.login,
            :client => routine.client.login,
            :activity_sets => routine.activity_sets.map do |set|
            {
                :activity => set.activity.name,
                :position => set.position,
                :repetitions => set.repetitions,
                :duration => set.measurement.duration,
                :pace => set.measurement.pace,
                :calories => set.measurement.calories,
                :resistance => set.measurement.resistance,
                :incline => set.measurement.incline
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
    @routine = normalize_routine(current_user, params[:routine])
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
      :trainer => routine.trainer.login,
      :client => routine.client.login,
      :activity_sets => routine.activity_sets.map do |set|
        {
          :activity => set.activity.name,
          :repetitions => set.repetitions,
          :position => set.position,
          :duration => set.measurement.duration,
          :pace => set.measurement.pace,
          :calories => set.measurement.calories,
          :resistance => set.measurement.resistance,
          :incline => set.measurement.incline
        }
      end
    }
  end

  def normalize_routine(trainer, routine_hash)
    routine = Routine.new
    routine.trainer = trainer
    routine.name = routine_hash[:name]
    routine.goal = routine_hash[:goal]
    routine.owner = trainer
    routine.client = User.find_by_login(routine_hash[:client])
    
    position = 0
    routine_hash[:activity_sets].each do |activity_set_hash|
      position += 1
      activity = Activity.find_by_name(activity_set_hash[:activity])      
      
      measurement_hash = {
        :resistance => activity_set_hash[:resistance],
        :distance => activity_set_hash[:distance],
        :pace => activity_set_hash[:pace],
        :calories => activity_set_hash[:calories],
        :incline => activity_set_hash[:incline]
      }

      measurement = Measurement.find_or_create(measurement_hash)
      
      activity_set = ActivitySet.new
      activity_set.routine = routine
      activity_set.activity = activity
      activity_set.repetitions = activity_set_hash[:repetitions]
      activity_set.measurement = measurement
      activity_set.position = position
      
      routine.activity_sets << activity_set
    end
    
    routine
  end
  
end
