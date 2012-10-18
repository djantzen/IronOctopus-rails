class UsersController < ApplicationController

  respond_to :html
  before_filter :authenticate_user, :except => [:new, :create]

  def new 
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    invitation_uuid = params[:invitation_uuid]
    User.transaction do

      if @user.save
        @user.trainers << @user # Every user can self-train
        (1..5).each do
          @user.licenses << License.new(:trainer => @user, :client => @user)
        end

        if invitation_uuid # they are legit, don't send confirmation email
          invitation = Invitation.find_by_invitation_uuid(invitation_uuid)
          license = invitation.license
          license.client = @user
          license.status = 'assigned'
          license.save
          @user.identity_confirmed = true
          @user.trainers << license.trainer
          @user.save
          session[:user_id] = @user.user_id
          render :html => @user
        else
          mail = UserMailer.welcome_email(@user, request)
          mail.deliver
          redirect_to post_signup_path
        end

      else
        render :new
      end

    end

  end

  def update
    user_hash = params[:user]
    @client = User.find_by_login(params[:id])
    #active_program = Program.find_by_permalink(user_hash[:active_program])
    #@client.active_program = active_program
    #@client.save
    redirect_to user_path(@client)
  end

  def clients
    @clients = current_user.clients
  end

  def index
#    @users = User.all
#    render :json => users
  end

  # GET /users/1.json
  def show
    @client = User.find_by_login(params['id'])
    @routines = @client.routines
    @todays_routines = @client.todays_routines
    #    @weekday_programs = @user.weekday_programs
#    @scheduled_programs = @user.weekday_programs
    @programs = @client.programs
    @program_select =  @programs.map { |p| [p.name, p.permalink] }
#    @active_program = current_user.active_program || @programs.first

    respond_with do |format|
      format.html { render :html => @user }
    end
     
  end

  
end
