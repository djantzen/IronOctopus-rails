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
      # Carrierwave works best(only?) with update_attributes so fake our hash
      image_params = params
      image_params[:user].delete(:new_password)
      image_params[:user].delete(:confirm_password)
      image_params[:user].delete(:city)
      @user.update_attributes(image_params[:user])
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

  def get_date_range
    start_date = DateTime.parse(params[:start_date]).at_beginning_of_day.utc
    end_date = DateTime.parse(params[:end_date]).end_of_day.utc
    [start_date, end_date]
  end

  def scores_by_day
    user = User.find_by_login(params[:user_id])
    start_date, end_date = get_date_range()
    scores = Charts::ByDayClientScore.find_by_user_and_dates(user, start_date, end_date)

    rows = scores.inject([]) do |memo, score|
      row = []
      row << score.full_date
      row << score.routine_score
      row << (score.prescribed_routine_name.nil? ? nil : score.prescribed_routine_name + ": " + score.routine_score.to_s)
      row << score.work_score
      row << (score.work_routine_name.nil? ? nil : "#{user.first_name} scored #{score.work_score.to_s} points while performing #{score.work_routine_name}")
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
        :title => "#{user.full_name}'s Score by Day",
        :legend => "bottom",
        :seriesType => "line",
        :series => { 0 => { :type => "bars" }, 1 => { :type => "bars" } },
        :hAxis => { :slantedText => false }
      }
    }
  end

  def client_score_differentials
    user = User.find_by_login(params[:user_id])
    start_date, end_date = get_date_range()
    levels = Charts::ClientScoreDifferentials.get_differentials(user, start_date, end_date)

    cols = [{:type => "string", :label => "Client", :role => "domain"},
            {:type => "number", :label => "Weekly Score Differential", :role => "data"}]
    rows = levels.inject([]) do |memo, level|
      row = [view_context.link_to(level.client_name, level.client_login), level.score]
      memo << row
    end

    render :json => {
      :type => "Table",
      :cols => cols,
      :rows => rows,
      :formatter => {
        :type => "TableBarFormat",
        :options => {
          :drawZeroLine => true,
          :colorPositive => "green",
          :min => -2000,
          :max => 1000,
          :showValue => true
        }
      },
      :options => {
        :allowHtml => true
      }
    }
  end

  def activity_type_breakdown
    user = User.find_by_login(params[:user_id])
    start_date, end_date = get_date_range()
    breakdowns = Charts::ActivityTypeBreakdown.find_by_user_and_dates(user, start_date, end_date)

    cols = [{:type => "string", :label => "Activity Type", :role => "domain"},
            {:type => "number", :label => "Count", :role => "data"}]
    rows = breakdowns.inject([]) do |memo, breakdown|
      memo << [breakdown.activity_type_name, breakdown.count]
      memo
    end

    render :json => {
      :type => "PieChart",
      :cols => cols,
      :rows => rows,
      :options => {
        :title => "#{user.full_name}'s Activity Breakdown by Type",
        :legend => "right",
        :is3d => false
      }
    }
  end

  def body_part_breakdown
    user = User.find_by_login(params[:user_id])
    start_date, end_date = get_date_range()
    breakdowns = Charts::BodyPartBreakdown.find_by_user_and_dates(user, start_date, end_date)

    cols = [{:type => "string", :label => "Body Region", :role => "domain"},
            {:type => "number", :label => "Count", :role => "data"}]
    rows = breakdowns.inject([]) do |memo, breakdown|
      memo << [breakdown.body_region, breakdown.count]
      memo
    end

    render :json => {
      :type => "PieChart",
      :cols => cols,
      :rows => rows,
      :options => {
        :title => "#{user.full_name}'s Activity Breakdown by Body Region",
        :legend => "right",
        :is3d => false
      }
    }
  end

  def activity_performance_over_time
    user = User.find_by_login(params[:user_id])
    activity = Activity.find_by_name params[:activity_name]
    performances = Charts::ByDayActivityMeasurements.find_by_user_date_and_activity(user, activity)
    units = params[:units]
    data_set = {}
    Metric.list.each do |metric|
      cols = [{:type => "string", :label => "Date", :role => "domain"},
              {:type => "number", :label => metric.name, :role => "data"}]

      rows = performances.inject([]) do |memo, performance|
        memo << [performance.full_date, performance.send(metric.name.to_identifier, units)]
        memo
      end

      data_set[metric.name] = {
        :type => "ColumnChart",
        :cols => cols,
        :rows => rows,
        :options => {
          :title => metric.name,
          :legend => "none",
        }
      }

    end

    render :json => data_set
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
