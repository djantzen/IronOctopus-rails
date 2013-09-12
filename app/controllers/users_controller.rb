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

    legend = ["Prescribed Score", "Actual Score", "Total Prescribed Score", "Total Actual Score"]
    x_axis_labels = []
    prescribed_scores = []
    actual_scores = []
    total_prescribed_scores = []
    total_actual_scores = []
    scores.each do |score|
      x_axis_labels << score.full_date.month.to_s + "-" + score.full_date.mday.to_s
      prescribed_scores << score.routine_score
      actual_scores << score.work_score
      total_prescribed_scores << score.total_prescribed_score
      total_actual_scores << score.total_actual_score
    end

    @chart_url = Gchart.line(:data => [prescribed_scores, actual_scores, total_prescribed_scores, total_actual_scores],
                             :axis_with_labels => 'x', :line_colors => "FF0000,00FF00,00AA00,DDFF00",
                             :axis_labels => [x_axis_labels.join('|')], :legend => legend, :size => '600x200')
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
