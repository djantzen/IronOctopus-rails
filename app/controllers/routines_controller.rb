class RoutinesController < ApplicationController

  include RoutinesHelper
  respond_to :json, :html

  def index
    user = User.find_by_login(params[:user_id])
    @routines = Routine.find(:all, :conditions => "client_id = #{user.user_id}")
    
    denorm_routines = @routines.map do |routine|
      denormalize_routine(routine)
    end
    
    respond_with do |format|
      format.html { render :html => @routines }
      format.json { render :json => denorm_routines.to_json }
    end
  end
      
  def new
    @routine = Routine.new
    @trainer = current_user
    @clients = current_user.clients.map { |u| ["#{u.first_name} #{u.last_name}", u.login] }
    @client = params[:user_id].nil? ? nil : User.find(params[:user_id]) 
    @activity_types = ActivityType.find(:all)
    @activities = Activity.find(:all, :include => [:body_parts, :implements, :activity_type], :order => :name)
    @implements = Implement.find(:all)
    @body_parts = BodyPart.find(:all)
  end

  def create
    routine = normalize_routine(Routine.new, params[:routine])
    routine.save
    redirect_to(routine.client)
#     redirect_to(user_routine_path, routine.client, routine)
  end

  def show
    @routine = Routine.find(params[:id])
    respond_with do |format|
      format.html { render :html => @routine }
      format.json { render :json => denormalize_routine(@routine).to_json }
    end
  end

  def edit
    @routine = Routine.find(params[:id])
    @trainer = current_user
    @clients = current_user.clients.map { |u| u.login }
    @client = params[:user_id].nil? ? nil : User.find(params[:user_id]) 
    @activity_types = ActivityType.find(:all)
    @activities = Activity.find(:all, :include => [:body_parts, :implements, :activity_type], :order => :name)
    @implements = Implement.find(:all)
    @body_parts = BodyPart.find(:all)
  end
  
  def update
    routine = Routine.find(params[:id])
    routine.activity_sets.each do |activity_set|
      activity_set.delete
    end
    normalize_routine(routine, params[:routine])    
    routine.save
    redirect_to(routine.client)
  end

  def denormalize_routine(routine)
    {
      :routine_key => routine.name.to_identifier,
      :name => routine.name,
      :goal => routine.goal,
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

  def normalize_routine(routine, params)
    routine.trainer = User.find_by_login(params[:trainer]) if routine.trainer.nil?
    routine.name = params[:name]
    routine.goal = params[:goal]
    routine.client = User.find_by_login(params[:client]) if routine.client.nil?
    
    position = 0
    params[:activity_sets].each do |activity_set_hash|
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
