class RoutinesController < ApplicationController

  before_filter :authenticate_user#, :except => [:is_name_unique, :index, :fetch_activity_sets]
  include RoutinesHelper
  respond_to :json, :html, :js

  helper_method :allowed_to_update?
  helper_method :allowed_to_read?
  helper_method :allowed_to_perform?

  def index
    @client = User.find_by_login(params[:user_id])
    @routines = Routine.all(:conditions => { :client_id => @client.user_id }, :order => :name)

    respond_with do |format|
      format.js { render :html => @routines, :template => "routines/by_client" }
      format.html { render :html => @routines }
      format.json {
        denorm_routines = @routines.map do |routine|
          denormalize_routine(routine)
        end
        render :json => denorm_routines.to_json
      }
    end
  end

  def is_name_unique
    user = User.find_by_login(params[:user_id])
    routine_id = params[:routine_id]
    routine = Routine.first(:conditions => { :client_id => user.user_id, :permalink => routine_id.to_identifier })
    respond_with do |format|
      format.json { render :json => routine.nil? }
    end
  end

  def new
    new_or_edit
    @routine = Routine.new
    redirect_to user_path(current_user) unless allowed_to_create?
  end

  def create
    @routine = normalize_routine(Routine.new, params[:routine])
    if @routine.errors.empty? #@routine.save
      respond_with do |format|
        format.html { render :html => @routine }
      end
    else
      @entity = @routine
      respond_with do |format|
        format.html { render :html => @entity, :template => "shared/entity_errors" }
      end
    end
  end

  def show
    client = User.find_by_login(params[:user_id])
    @routine = Routine.first(:conditions => { :client_id => client.user_id, :permalink => params[:id] })
    redirect_to user_path(current_user) unless allowed_to_read?
    respond_with do |format|
      format.html { render :html => @routine }
    end
  end

  def perform
    @client = User.find_by_login(params[:user_id])
    @routine = Routine.first(:conditions => { :client_id => @client.user_id, :permalink => params[:routine_id] })
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
    new_or_edit
    @routine = Routine.first(:conditions => { :client_id => @client.user_id, :permalink => params[:id] })
    redirect_to user_path(current_user) unless allowed_to_update?
  end

  def update
    @client = User.find_by_login(params[:user_id])
    @routine = Routine.first(:conditions => { :client_id => @client.user_id, :permalink => params[:id] })

    @routine = normalize_routine(@routine, params[:routine])
    if @routine.errors.empty?
      respond_with do |format|
        format.html { render :html => @routine }
      end
    else
      @entity = @routine
      respond_with do |format|
        format.html { render :html => @entity, :template => "shared/entity_errors" }
      end
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

  def fetch_activity_sets
    user = User.find_by_login(params[:user_id])
    routine = Routine.first(:conditions => { :client_id => user.user_id, :permalink => params[:routine_id] })

    @activity_sets = routine.activity_sets
    respond_with do |format|
      format.json { render :json => @activity_sets }
      format.html { render :html => @activity_sets }
    end

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
          :position => set.position,
          :repetitions => set.measurement.repetitions,
          :cadence => set.measurement.cadence,
          :calories => set.measurement.calories,
          :distance => set.measurement.distance,
          :duration => set.measurement.duration,
          :heart_rate => set.measurement.heart_rate,
          :incline => set.measurement.incline,
          :level => set.measurement.level,
          :resistance => set.measurement.resistance,
          :speed => set.measurement.speed
        }
      end
    }
  end

  def normalize_routine(routine, params)
    Routine.transaction do
      routine.trainer = User.find_by_login(params[:trainer]) if routine.trainer.nil?
      routine.name = params[:name]
      routine.goal = params[:goal]
      routine.client = User.find_by_login(params[:client]) if routine.client.nil?
      routine.activity_sets.each do |activity_set|
        activity_set.delete
      end
      routine.activity_sets.clear

      position = 0
      (params[:activity_sets] || []).each do |activity_set_hash|
        position += 1
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
          :heart_rate => activity_set_hash[:heart_rate].to_i,
          :incline => activity_set_hash[:incline].to_f,
          :level => activity_set_hash[:level].to_i,
          :repetitions => activity_set_hash[:repetitions].to_i,
          :resistance => Unit.convert_to_kilograms(activity_set_hash[:resistance].to_f, unit_hash[:resistance_unit].name),
          :speed => Unit.convert_to_kilometers_per_hour(activity_set_hash[:speed].to_f, unit_hash[:speed_unit].name),
        }

        measurement = Measurement.find_or_create(measurement_hash)
        unit_set = UnitSet.find_or_create(unit_hash)

        activity_set = ActivitySet.new

        activity_set.routine = routine
        activity_set.activity = activity
        activity_set.position = position
        activity_set.unit_set = unit_set
        activity_set.measurement = measurement

        routine.activity_sets << activity_set
      end
      routine.save
    end

    routine
  end

  private
  def new_or_edit
    @client = params[:user_id].nil? ? nil : User.find_by_login(params[:user_id])
    @trainer = current_user
    @client_logins = current_user.clients.order(:last_name, :first_name).map { |u| ["#{u.first_name} #{u.last_name}", u.login] }
    @activities = Activity.all(:include => [:body_parts, :implements, :activity_type], :order => :name)
    @activity_types = ActivityType.all
    @implements = Implement.all
    @body_parts = BodyPart.all
    @activity = Activity.new
    @metrics = Metric.list
    @activity_attributes = ActivityAttribute.all(:order => :name)
  end

  def allowed_to_create?
    @client.trainers.include? @trainer
  end

  def allowed_to_update?
    current_user.eql? @routine.trainer
  end

  def allowed_to_read?
    current_user.eql?(@routine.trainer) || current_user.eql?(@routine.client)
  end

  def allowed_to_perform?
    current_user.eql?(@routine.trainer) || current_user.eql?(@routine.client)
  end

end
