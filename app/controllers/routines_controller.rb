class RoutinesController < ApplicationController

  before_filter :authenticate_user
  include RoutinesHelper
  respond_to :json, :html, :js

  def index
    @client = User.find_by_login(params[:user_id])
    @routines = Routine.all(:conditions => { :client_id => @client.user_id }, :order => :name)

    respond_with do |format|
      format.js { render :html => @routines, :template => "routines/by_client" }
      format.html { render :html => @routines }
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
    authorize! :create, Routine.new, @client
  end

  def create
    @routine = create_or_update(Routine.new, params[:routine])
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

  def show
    client = User.find_by_login(params[:user_id])
    @routine = Routine.first(:conditions => { :client_id => client.user_id, :permalink => params[:id] })

    authorize! :read, @routine
    respond_with do |format|
      format.html { render :html => @routine }
    end
  end

  def perform
    @client = User.find_by_login(params[:user_id])
    @routine = Routine.first(:conditions => { :client_id => @client.user_id, :permalink => params[:routine_id] })
    @activities = Activity.order(:name).includes(:activity_type)
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
    authorize! :update, @routine
  end

  def update
    @client = User.find_by_login(params[:user_id])
    @routine = Routine.first(:conditions => { :client_id => @client.user_id, :permalink => params[:id] })

    @routine = create_or_update(@routine, params[:routine])
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

  private

  def create_or_update(routine, params)
    Routine.transaction do
      routine.trainer = User.find_by_login(params[:trainer]) if routine.trainer.nil?
      routine.name = params[:name]
      routine.goal = params[:goal]
      routine.client = User.find_by_login(params[:client]) if routine.client.nil?

      # Delete all existing ActivitySetGroups and ActivitySets
      routine.activity_sets.clear
      routine.activity_set_groups.clear

      position = 0
      (params[:activity_set_groups] || []).each do |activity_set_group_map|
        activity_set_group = ActivitySetGroup.new
        activity_set_group.sets = activity_set_group_map[:set_count]
        activity_set_group.name = activity_set_group_map[:group_name] # change to name

        routine.activity_set_groups << activity_set_group

        (activity_set_group_map[:activity_sets] || []).each do |activity_set_map|
          position += 1

          activity = Activity.find_by_name(activity_set_map[:activity])
          unit_map = Unit.activity_set_to_unit_map(activity_set_map)
          metric_map = Measurement.activity_set_to_metric_map(activity_set_map, unit_map)
          measurement = Measurement.find_or_create(metric_map)
          unit_set = UnitSet.find_or_create(unit_map)

          activity_set = ActivitySet.new
          activity_set.comments = activity_set_map[:comments]
          activity_set.routine = routine
          activity_set.activity = activity
          activity_set.position = position
          activity_set.unit_set = unit_set
          activity_set.measurement = measurement
          activity_set_group.activity_sets << activity_set
          routine.activity_sets << activity_set

        end

      end
      routine.save
    end

    routine
  end

  def new_or_edit
    @client = params[:user_id].nil? ? nil : User.find_by_login(params[:user_id])
    @trainer = current_user
    @client_logins = current_user.clients.order(:last_name, :first_name).map { |u| ["#{u.first_name} #{u.last_name}", u.login] }
    @activities = Activity.all(:include => [:body_parts, :implements, :activity_type], :order => :name)
    @activity_types = ActivityType.order(:name)
    @implements = Implement.order(:category, :name)
    @body_parts = BodyPart.order(:region, :name)
    @activity_attributes = ActivityAttribute.order(:name)
    @activity = Activity.new
    @metrics = Metric.list
  end

end
