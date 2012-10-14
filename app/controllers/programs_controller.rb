class ProgramsController < ApplicationController

  before_filter :authenticate_user
  include ProgramsHelper
  helper LaterDude::CalendarHelper
  respond_to :json, :html

  WEEKDAYS = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']

  def show
    @program = Program.find_by_permalink(params[:id].to_identifier)
    @client = User.find_by_login(params[:user_id])
    @trainer = current_user
    @routines = @client.routines
    @routine_select =  @routines.map { |r| [r.name, r.permalink] }
    @clients = current_user.clients
  end

  def new
    @program = Program.new
    @weekday_programs = @program.weekday_programs
    @scheduled_programs = @program.scheduled_programs
    @client = User.find_by_login(params[:user_id])
    @trainer = current_user
    @routines = @client.routines
    @routine_select =  @routines.map { |r| [r.name, r.permalink] }
    @clients = current_user.clients
    _routine_builder_attributes
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
  end

  def create
    program = _create_or_update(Program.new)
    redirect_to(user_programs_path(program.client))
  end

  def edit
    @program = Program.find_by_permalink(params[:id].to_identifier)
    @weekday_programs = @program.weekday_programs
    @scheduled_programs = @program.scheduled_programs
    @client = User.find_by_login(params[:user_id])
    @trainer = current_user
    @routines = @client.routines
    @routine_select =  @routines.map { |r| [r.name, r.permalink] }
    @clients = current_user.clients
    _routine_builder_attributes
  end

  def update
    program = _create_or_update(Program.find_by_permalink(params[:program][:name].to_identifier))
    redirect_to(user_programs_path(program.client))
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

      if program_type.eql? 'weekly'
        program.weekday_programs.each do |wp|
          wp.delete
        end
        WEEKDAYS.each do |weekday|
          routine = Routine.find_by_permalink(program_hash[weekday])
          next if routine.nil?
          weekday_program = WeekdayProgram.new(:routine => routine, :program => program, :day_of_week => weekday)
          program.weekday_programs << weekday_program  #unless program.routines.include?(routine)
        end
      elsif program_type.eql? 'scheduled'
        program.scheduled_programs.each do |sp|
          sp.delete
        end
        dates_and_routines = program_hash[:dates]
        dates_and_routines.each do |date, routine_permalink|
          next if routine_permalink.nil?
          routine = Routine.find_by_permalink(routine_permalink)
          next if routine.nil?
          scheduled_program = ScheduledProgram.new(:routine => routine, :program => program, :scheduled_on => date)
          program.scheduled_programs << scheduled_program
        end
      else
        raise ArgumentError.new("Unknown program type #{type}")
      end
      program.save
    end
    program
  end

end
