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
        @user.licenses << License.new(:trainer => @user, :client => @user) # free license

        if invitation_uuid # they are legit, don't send confirmation email
          invitation = Invitation.find_by_invitation_uuid(invitation_uuid)
          license = invitation.license
          license.client = @user
          license.status = 'assigned'
          license.save
          invitation.accepted = true
          invitation.save
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
    @user = User.find_by_login(params[:id])
    authorize! :update, @user
    User.transaction do
      if !params[:user][:new_password].blank? && params[:user][:new_password].eql?(params[:user][:confirm_password])
        @user.password = params[:user][:new_password]
      end
      city_name, state_name = params[:city].split(/,/)
      city = City.find_by_name_and_state(city_name, state_name)
      @user.city = city
      @user.save
    end
    @flash = "Settings Updated"
    @todays_routines = @user.todays_routines
    @programs = @user.programs
    @program_select =  @programs.map { |p| [p.name, p.permalink] }
    @routines = @user.routines
  end

  def clients
    @clients = current_user.clients
  end

  def index
    authorize! :read, User.new, current_user
    @users = User.order(:created_at)
  end

  def show
    @user = User.find_by_login(params[:id])
    authorize! :read, @user
    @routines = @user.routines
    @todays_routines = @user.todays_routines
    @programs = @user.programs
    @program_select =  @programs.map { |p| [p.name, p.permalink] }
    respond_with do |format|
      format.html { render :html => @user, :template => mobile_device? ? "users/mobile_show" : "users/show" }
    end
  end

  def scores_by_day
    user = User.find_by_login(params[:user_id])
    start_date = Date.parse params[:start_date]
    end_date = Date.parse params[:end_date]
    scores = ByDayClientScore.find_by_user_and_dates(user, start_date, end_date)

    rows = scores.inject([]) do |memo, score|
      row = []
      row << score.full_date.month.to_s + "-" + score.full_date.mday.to_s
      row << score.routine_score
      row << (score.prescribed_routine_name.nil? ? nil : score.prescribed_routine_name + ": " + score.routine_score.to_s)
      row << score.work_score
      row << (score.work_routine_name.nil? ? nil : score.work_routine_name + ": " + score.work_score.to_s)
      row << score.total_prescribed_score
      row << score.total_actual_score
      memo << row
    end

    render :json => {
      :type => "ComboChart",
      :cols => [{:type => "string", :label => "Date", :role => "domain"},
                {:type => "number", :label => "Prescribed Score", :role => "data"},
                {:type => "string", :label => "Prescribed Routine", :role => "tooltip"},
                {:type => "number", :label => "Actual Score", :role => "data"},
                {:type => "string", :label => "Actual Routine", :role => "tooltip"},
                {:type => "number", :label => "Total Prescribed Score", :role => "data"},
                {:type => "number", :label => "Total Actual Score", :role => "data"}
                ],
      :rows => rows,
      :options => {
        :title => "Client Score by Day",
        :legend => "bottom",
        :seriesType => "line",
        :series => { 0 => { :type => "bars" }, 1 => { :type => "bars" } }
      }
    }

  end

  def settings
    @user = User.find_by_login(params[:user_id])
    authorize! :update, @user
  end

  def is_login_unique
    user = User.find_by_login(params[:login])
    respond_with do |format|
      format.json { render :json => user.nil? }
    end

  end

end
