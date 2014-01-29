class DayPlannersController < ApplicationController

  def new
    create_or_update
  end

  def create

  end

  def edit

  end

  def update

  end

  def create_or_update
    @trainer = User.find_by_login(params[:user_id])
    @clients = @trainer.clients # order by last appointment
    @today = DateTime.now.in_time_zone(@trainer.timezone.tzid).to_date
    @last_week = (@today.beginning_of_week - 1.week .. @today.end_of_week - 1.week)

    @this_week = (@today.beginning_of_week(:sunday) .. @today.end_of_week(:sunday)).map do |date|
      [ date, date_to_date_time_ranges(date, @trainer.timezone.tzid) ]
    end
    @next_week = (@today.beginning_of_week(:sunday) + 1.week .. @today.end_of_week(:sunday) + 1.week)

    clause = "lower(date_time_slot) between '#{@today.beginning_of_week(:sunday).iso8601}' and '#{@today.end_of_week(:sunday).iso8601}'"
    @appointment_map = {}
    @trainer.recurring_appointments.where(clause).each do |appointment|
      @appointment_map[appointment.local_date_time_slot.to_identifier] = appointment
    end
    @trainer.appointments.where(clause).each do |appointment|
      @appointment_map[appointment.local_date_time_slot.to_identifier] = appointment
    end
    routine_builder_attributes
  end

  private

  def date_to_date_time_ranges(date, trainer_timezone_id)
    Time.zone = trainer_timezone_id
    ranges = (6..20).map do |hour|
      start = Time.new(date.year, date.month, date.day, hour).to_datetime
      the_end = start + 1.hour - 1.second
      DateTimeRange.new(start, the_end)
    end
    Time.zone = "UTC"
    ranges
  end

  def routine_builder_attributes
    @routine = Routine.new
    @client_logins = current_user.clients.map { |u| ["#{u.first_name} #{u.last_name}", u.login] }
    @client = User.first # dummy
    @activities = Activity.all(:include => [:body_parts, :implements, :activity_type], :order => :name)
    @activity_types = ActivityType.order(:name)
    @implements = Implement.order(:category, :name)
    @body_parts = BodyPart.order(:region, :name)
    @activity_attributes = ActivityAttribute.order(:name)
    @metrics = Metric.all(:conditions => "name != 'None'")
    @activity = Activity.new
  end

end
