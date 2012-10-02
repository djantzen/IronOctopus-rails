class ProgramsController < ApplicationController

  def show

  end

  def new
    @program = Program.new
    @client = User.find_by_login(params[:user_id])
    @trainer = current_user
    @routines = @client.routines
    @clients = current_user.clients

  end

  def create
    _create_or_update
  end

  def update

  end

  def index

  end

  def _create_or_update
    program_hash = params[:program]
    client = User.find_by_login(program_hash[:client])
    trainer = User.find_by_login(program_hash[:trainer])

    program = Program.new(:name => program_hash[:name],
                          :goal => program_hash[:goal],
                          :client => client, :trainer => trainer)
    program.save
  end

end
