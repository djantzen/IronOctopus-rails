class UsersController < ApplicationController

  respond_to :html, :json
  before_filter :authenticate_user, :except => [:new, :create, :is_login_unique]

  def new
    @user = User.new
    @states = State.order(:name)
  end

  def create
    @user = User.new(params[:user])
    invitation_uuid = params[:invitation_uuid]
    city_name, state_name = params[:city].split(/,/)
    city = City.find_by_name_and_state(city_name, state_name)
    @user.city = city

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
    @client = User.find_by_login(params[:id])
    allowed_to_update?
    if @client.eql? current_user
      User.transaction do
        if !params[:user][:new_password].blank? && params[:user][:new_password].eql?(params[:user][:confirm_password])
          @client.password = params[:user][:new_password]
        end
        city_name, state_name = params[:city].split(/,/)
        city = City.find_by_name_and_state(city_name, state_name)
        @client.city = city
        @client.save
      end
    end
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
    @user = User.find_by_login(params['id'])
    @routines = @user.routines
    @todays_routines = @user.todays_routines
    @programs = @user.programs
    @program_select =  @programs.map { |p| [p.name, p.permalink] }
    respond_with do |format|
      format.html { render :html => @user, :template => mobile_device? ? "users/mobile_show" : "users/show" }
    end
     
  end

  def settings
    @client = User.find_by_login(params[:user_id])
    allowed_to_update?
  end

  def is_login_unique
    user = User.find_by_login(params[:login])
    respond_with do |format|
      format.json { render :json => user.nil? }
    end

  end

  private
  def allowed_to_read?
    current_user.eql?(@client) || @client.trainers.include?(current_user)
  end

  def allowed_to_update?
    current_user.eql?(@client)
  end

end
