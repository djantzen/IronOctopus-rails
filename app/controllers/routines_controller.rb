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
    @routine = create_or_update(Routine.new)
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
    @routine = Routine.where(:client_id => client.user_id, :permalink => params[:id]).first

    authorize! :read, @routine
    respond_with do |format|
      format.html { render :html => @routine }
    end
  end

  def perform
    @client = User.find_by_login(params[:user_id])
    @routine = Routine.where(:client_id => @client.user_id, :permalink => params[:routine_id]).first
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
    @routine = Routine.where(:client_id => @client.user_id, :permalink => params[:id]).first
    authorize! :update, @routine
  end

  def update
    @client = User.find_by_login(params[:user_id])
    @routine = Routine.where(:client_id => @client.user_id, :permalink => params[:id]).first

    @routine = create_or_update(@routine)
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
    routine = Routine.where(:client_id => user.user_id, :permalink => params[:routine_id]).first

    @activity_sets = routine.activity_sets
    respond_with do |format|
      format.json { render :json => @activity_sets }
      format.html { render :html => @activity_sets }
    end

  end

  private

  def create_or_update(routine)
    Routine.transaction do
      routine.trainer = User.find_by_login(params[:routine][:trainer]) if routine.trainer.nil?
      routine.name = params[:routine][:name]
      routine.goal = params[:routine][:goal]
      routine.client = User.find_by_login(params[:user_id]) if routine.client.nil?

      # Delete all existing ActivitySetGroups and ActivitySets
      routine.activity_set_groups.each do |group|
        group.activity_sets.clear
      end
      routine.activity_set_groups.clear

      position = 0
      routine.activity_set_groups = (params[:routine][:activity_set_groups] || []).map do |activity_set_group_map|
        activity_set_group = ActivitySetGroup.new(:name => activity_set_group_map[:group_name], :sets => activity_set_group_map[:set_count],
                                                  :rest_interval =>  Unit.convert_to_seconds(activity_set_group_map[:rest_interval], Unit::NONE))

        activity_set_group.activity_sets = (activity_set_group_map[:activity_sets] || []).map do |activity_set_map|
          position += 1

          activity = Activity.find_by_name(activity_set_map[:activity])
          unit_map = Unit.activity_set_to_unit_map(activity_set_map)
          metric_map = Measurement.activity_set_to_metric_map(activity_set_map, unit_map)
          measurement = Measurement.find_or_create(metric_map)
          unit_set = UnitSet.find_or_create(unit_map)

          ActivitySet.new(:activity => activity, :comments => activity_set_map[:comments],
                          :position => position, :unit_set => unit_set, :measurement => measurement)
        end

        activity_set_group
      end
      routine.save
    end

    routine
  end

  def new_or_edit
    @client = params[:user_id].nil? ? nil : User.find_by_login(params[:user_id])
    @trainer = current_user
    @client_logins = current_user.clients.order(:last_name, :first_name).map { |u| ["#{u.first_name} #{u.last_name}", u.login] }
    @activities = Activity.all(:include => [:body_parts, :implements, :activity_type, :alternate_activity_names, :activity_images],
                               :order => :name)
    @activity_types = ActivityType.order(:name)
    @implements = Implement.order(:category, :name)
    @body_parts = BodyPart.order(:display_order, :name)
    @activity_attributes = ActivityAttribute.order(:name)
    @activity = Activity.new
    @metrics = Metric.list
  end

end
