class RoutinesController < ApplicationController
  include StringUtils
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
    @routine.creator = User.find(1)
    @routine.owner = User.find(3)
    @routine.save
#    activity = Activity.new()
#    activity.name = params['activity']['name']
#    activity.save
#    render :json => activity
  end

  # GET /activities/1.json
  def show
    routines = Routine.find(params[:id])
    
    render :json => routines
  end

  
end
