class RoutinesController < ApplicationController

  include RoutinesHelper
  respond_to :json, :html

  def index

    user = User.find_by_login(params[:user_id])

    @routines = Routine.all(:conditions => "client_id = #{user.user_id}", :order => :name)

    denorm_routines = @routines.map do |routine|
      denormalize_routine(routine)
    end

    respond_with do |format|
      format.html { render :html => @routines }
      format.json { render :json => denorm_routines.to_json }
    end
  end

  def by_trainer
    user = User.find_by_login(params[:user_id])
    @routines = Routine.all(:conditions => "trainer_id = #{user.user_id} and client_id != #{user.user_id}",
                            :order => :name)

    respond_with do |format|
      format.html { render :html => @routines, :template => "routines/index" }
    end

  end

  def new
    @routine = Routine.new
    @trainer = current_user
    @clients = current_user.clients.map { |u| ["#{u.first_name} #{u.last_name}", u.login] }
    @client = params[:user_id].nil? ? nil : User.find_by_login(params[:user_id])
    @activity_types = ActivityType.all
    @activities = Activity.all(:include => [:body_parts, :implements, :activity_type], :order => :name)
    @implements = Implement.all
    @body_parts = BodyPart.all
  end

  def create
    routine = normalize_routine(Routine.new, params[:routine])
    routine.save
    redirect_to user_routine_path(routine.client, routine)
  end

  def show
    client = User.find_by_login(params[:user_id])
    @routine = Routine.first(:conditions => { :client_id => client.user_id, :permalink => params[:id] })
    respond_with do |format|
      format.html { render :html => @routine }
    end
  end

  def perform
    client = User.find_by_login(params[:user_id])
    @routine = Routine.first(:conditions => { :client_id => client.user_id, :permalink => params[:routine_id] })
    respond_with do |format|
      format.html { render :html => @routine }
    end
  end

  def sheet
    client = User.find_by_login(params[:user_id])
    @routine = Routine.first(:conditions => { :client_id => client.user_id, :permalink => params[:routine_id] })
    respond_with do |format|
      format.html { render :html => @routine }
    end
  end

  def edit
    @client = User.find_by_login(params[:user_id])
    @routine = Routine.first(:conditions => { :client_id => @client.user_id, :permalink => params[:id] })
    @trainer = current_user
    @clients = current_user.clients.map { |u| u.login }
    @activity_types = ActivityType.all
    @activities = Activity.all(:include => [:body_parts, :implements, :activity_type], :order => :name)
    @implements = Implement.all
    @body_parts = BodyPart.all
  end
  
  def update
    client = User.find_by_login(params[:user_id])
    routine = Routine.first(:conditions => { :client_id => client.user_id, :permalink => params[:id] })
#    transaction do
      routine.activity_sets.each do |activity_set|
        activity_set.delete
      end
      normalize_routine(routine, params[:routine])
      routine.save
 #   end
    redirect_to(user_routine_path(client, routine))
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
          :distance => set.measurement.distance,
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
    (params[:activity_sets] || []).each do |activity_set_hash|
      position += 1
      activity = Activity.find_by_name(activity_set_hash[:activity])

      cadence_unit = Unit.lookup(activity_set_hash[:cadence_unit])
      distance_unit = Unit.lookup(activity_set_hash[:distance_unit])
      duration_unit = Unit.lookup(activity_set_hash[:duration_unit])
      speed_unit = Unit.lookup(activity_set_hash[:speed_unit])
      resistance_unit = Unit.lookup(activity_set_hash[:resistance_unit])

      measurement_hash = {
        :calories => activity_set_hash[:calories],
        :cadence => activity_set_hash[:cadence],
        :distance => Unit.convert_to_meters(activity_set_hash[:distance].to_f, distance_unit.name),
        :duration => Unit.convert_to_seconds(activity_set_hash[:duration].to_f, duration_unit.name),
        :incline => activity_set_hash[:incline],
        :level => activity_set_hash[:level],
        :resistance => Unit.convert_to_kilograms(activity_set_hash[:resistance].to_f, resistance_unit.name),
        :speed => Unit.convert_to_kilometers_per_hour(activity_set_hash[:speed].to_f, speed_unit.name),
      }

      measurement = Measurement.find_or_create(measurement_hash)
      activity_set = ActivitySet.new
      activity_set.routine = routine
      activity_set.activity = activity
      activity_set.position = position
      activity_set.cadence_unit = cadence_unit
      activity_set.distance_unit = distance_unit
      activity_set.duration_unit = duration_unit
      activity_set.speed_unit = speed_unit
      activity_set.resistance_unit = resistance_unit
      activity_set.repetitions = activity_set_hash[:repetitions] || 1
      activity_set.measurement = measurement

      routine.activity_sets << activity_set
    end
    
    routine
  end

end
