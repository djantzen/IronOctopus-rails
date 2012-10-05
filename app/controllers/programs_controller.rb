class ProgramsController < ApplicationController

  before_filter :authenticate_user
  include ProgramsHelper
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
    @client = User.find_by_login(params[:user_id])
    @trainer = current_user
    @routines = @client.routines
    @routine_select =  @routines.map { |r| [r.name, r.permalink] }
    @clients = current_user.clients
  end

  def create
    _create_or_update(Program.new)
  end

  def edit
    @program = Program.find_by_permalink(params[:id].to_identifier)
    @client = User.find_by_login(params[:user_id])
    @trainer = current_user
    @routines = @client.routines
    @routine_select =  @routines.map { |r| [r.name, r.permalink] }
    @clients = current_user.clients
  end

  def update
    program = _create_or_update(Program.find_by_permalink(params[:program][:name].to_identifier))
    redirect_to(user_program_path(program.client, program))
  end

  def index
    user = User.find_by_login(params[:user_id])
    @programs = Program.all(:conditions => "client_id = #{user.user_id}", :order => :name)

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
    client = User.find_by_login(program_hash[:client])
    trainer = User.find_by_login(program_hash[:trainer])
    Program.transaction do
      program.name = program_hash[:name]
      program.goal = program_hash[:goal]
      program.trainer = trainer
      program.client = client

      program.routines.clear

      WEEKDAYS.each do |weekday|
        routine = Routine.find_by_permalink(program_hash[weekday])
        program.routines << routine if routine #unless program.routines.include?(routine)
      end

      program.save

    end
    program
  end

end
