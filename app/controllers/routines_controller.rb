class RoutinesController < ApplicationController

  include RoutinesHelper
  respond_to :json, :html

  def index
    user = current_user
    
    @routines = Routine.find(:all, :conditions => "trainer_id = #{user.user_id}")
    
    denorm_routines = @routines.map do |routine|
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
    
    respond_with do |format|
      format.html { render :html => @routines }
      format.json { render :json => denorm_routines.to_json }
    end
  end
      
  def new
    @routine = Routine.new
    @clients = current_user.clients.map { |u| u.login }
    @activity_types = ActivityType.find(:all)
    @activities = Activity.find(:all, :include => [:body_parts, :implements, :activity_type], :order => :name)
    @implements = Implement.find(:all)
    @body_parts = BodyPart.find(:all)

  end

  def create
    wtf params
    @routine = normalize_routine(current_user, Routine.new, params[:routine])
    
    @routine.save
    redirect_to(@routine)
  end

  # GET /activities/1.json
  def show
    @routine = Routine.find(params[:id])
    respond_with do |format|
      format.html { render :html => @routine }
      format.json { render :json => denormalize_routine(@routine).to_json }
    end
  end

  def edit
    @routine = Routine.find(params[:id])
    @clients = current_user.clients.map { |u| u.login }
    @activity_types = ActivityType.find(:all)
    @activities = Activity.find(:all, :include => [:body_parts, :implements, :activity_type], :order => :name)
    @implements = Implement.find(:all)
    @body_parts = BodyPart.find(:all)
  end
  
  def update
    wtf params
    routine = params[:id] ? Routine.find(params[:id]) : Routine.new
    routine.activity_sets.each do |activity_set|
      activity_set.delete
    end
    @routine = normalize_routine(current_user, routine, params[:routine])
    
    @routine.save
    redirect_to(@routine)
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

  def normalize_routine(trainer, routine, routine_hash)
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

  #eh?
  def create_or_update(params)
    routine = params[:id] ? Routine.find(params[:id]) : normalize_routine(current_user, params[:routine])    
    routine
  end
  
end
