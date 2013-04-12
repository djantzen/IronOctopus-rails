class ProgramsController < ApplicationController

  before_filter :authenticate_user, :except => [:is_name_unique]
  include ProgramsHelper
  helper LaterDude::CalendarHelper
  respond_to :json, :html
  helper_method :allowed_to_update?

  def show
    @program = Program.find_by_permalink(params[:id].to_identifier)
    @client = User.find_by_login(params[:user_id])
    @trainer = current_user
    # TODO update when we support meridian
    @routines = @program.routines.values
    @routine_select =  @routines.map { |r| [r.name, r.permalink] }
    @clients = current_user.clients
    redirect_to user_path(current_user) unless allowed_to_read?
  end

  def new
    @program = Program.new
    @weekday_programs = @program.weekday_programs
    @scheduled_programs = @program.scheduled_programs
    @program_type = 'Weekday'
    @client = User.find_by_login(params[:user_id])
    @trainer = current_user
    @routines = @client.routines
    @routine_select =  @routines.map { |r| [r.name, r.permalink] }
    @clients = current_user.clients
    _routine_builder_attributes
    redirect_to user_path(current_user) unless allowed_to_create?
  end

  def _routine_builder_attributes
    @routine = Routine.new
    @calendars = [ LaterDude::Calendar.new(2012, 10), LaterDude::Calendar.new(2012, 11) ]
    @client_logins = current_user.clients.map { |u| ["#{u.first_name} #{u.last_name}", u.login] }
    @activity_types = ActivityType.all
    @activities = Activity.all(:include => [:body_parts, :implements, :activity_type], :order => :name)
    @implements = Implement.all
    @body_parts = BodyPart.all
    @activity_attributes = ActivityAttribute.all(:order => :name)
    @metrics = Metric.all(:conditions => "name != 'None'")
    @activity = Activity.new
  end

  def create
    @program = _create_or_update(Program.new)
    if @program.errors.empty?
      respond_with do |format|
        format.html { render :html => @program }
      end
    else
      @entity = @program
      respond_with do |format|
        format.html { render :html => @entity, :template => "shared/entity_errors" }
      end
    end
  end

  def edit
    @client = User.find_by_login(params[:user_id])
    @program = Program.first(:conditions => { :client_id => @client.user_id, :permalink => params[:id] })
    @trainer = current_user
    @weekday_programs = @program.weekday_programs
    @scheduled_programs = @program.scheduled_programs
    @program_type = @scheduled_programs.size > 0 ? 'Scheduled' : 'Weekday'
    @routines = @client.routines
    @routine_select =  @routines.map { |r| [r.name, r.permalink] }
    @clients = current_user.clients
    _routine_builder_attributes
    redirect_to user_path(current_user) unless allowed_to_update?
  end

  def update
    @client = User.find_by_login(params[:user_id])
    @program = Program.first(:conditions => { :client_id => @client.user_id, :permalink => params[:id].to_identifier })
    @program = _create_or_update(@program)
    if @program.errors.empty?
      respond_with do |format|
        format.html { render :html => @program }
      end
    else
      @entity = @program
      respond_with do |format|
        format.html { render :html => @entity, :template => "shared/entity_errors" }
      end
    end
  end

  def index
    @client = User.find_by_login(params[:user_id])
    @programs = Program.all(:conditions => "client_id = #{@client.user_id}", :order => :name)

    respond_with do |format|
      format.html { render :html => @programs }
    end
  end

  def by_trainer
    user = User.find_by_login(params[:user_id])
    @programs = Program.all(:conditions => "trainer_id = #{user.user_id} and client_id != #{user.user_id}",
                            :order => :name)

    respond_with do |format|
      format.html { render :html => @programs, :template => "programs/index" }
    end
  end

  def _create_or_update(program)
    program_hash = params[:program]
    program_type = program_hash[:type]
    client = User.find_by_login(program_hash[:client])
    trainer = User.find_by_login(program_hash[:trainer])
    Program.transaction do
      program.name = program_hash[:name]
      program.goal = program_hash[:goal]
      program.trainer = trainer
      program.client = client

      program.weekday_programs.each do |wp|
        wp.delete
      end
      program.weekday_programs.clear
      program.scheduled_programs.each do |sp|
        sp.delete
      end
      program.scheduled_programs.clear

      if program_type.eql? 'Weekday'
        Weekday::WEEK.each do |weekday|
          routine = Routine.find_by_permalink(program_hash[weekday.name])
          next if routine.nil?
          weekday_program = WeekdayProgram.new(:routine => routine, :program => program, :day_of_week => weekday.name)
          program.weekday_programs << weekday_program  #unless program.routines.include?(routine)
        end
      elsif program_type.eql? 'Scheduled'
        dates_and_routines = program_hash[:dates]
        dates_and_routines.each do |date, routine_permalink|
          next if routine_permalink.nil?
          routine = Routine.find_by_permalink(routine_permalink)
          next if routine.nil?
          scheduled_program = ScheduledProgram.new(:routine => routine, :program => program, :scheduled_on => date)
          program.scheduled_programs << scheduled_program
        end
      else
        raise ArgumentError.new("Unknown program type #{program_type}")
      end
      program.save
    end
    program
  end

  def is_name_unique
    user = User.find_by_login(params[:user_id])
    program_id = params[:program_id]
    program = Program.first(:conditions => { :client_id => user.user_id, :permalink => program_id.to_identifier })
    respond_with do |format|
      format.json { render :json => program.nil? }
    end
  end

  private
  def allowed_to_create?
    @client.trainers.include? @trainer
  end

  def allowed_to_update?
    current_user.eql? @program.trainer
  end

  def allowed_to_read?
    current_user.eql?(@program.trainer) || current_user.eql?(@program.client)
  end

end
