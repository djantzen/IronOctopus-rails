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
    # return last week, this week and next week
    # longer historical views can be provided via proper reports
    # need to load: routine info, client list,

    @clients = @trainer.clients # order by last appointment
    @today = DateTime.now.in_time_zone(@trainer.timezone.tzid).to_date
    @last_week = (@today.beginning_of_week - 1.week .. @today.end_of_week - 1.week)

    @this_week = (@today.beginning_of_week(:sunday) .. @today.end_of_week(:sunday)).map do |date|
      [ date, date_to_date_time_ranges(date, @trainer.timezone.tzid) ]
    end
    @next_week = (@today.beginning_of_week(:sunday) + 1.week .. @today.end_of_week(:sunday) + 1.week)

    clause = "lower(date_time_slot) between '#{@today.beginning_of_week(:sunday).iso8601}' and '#{@today.end_of_week(:sunday).iso8601}'"
    @appointment_map = {}
    @trainer.recurring_appointments.where(clause).each do |appt|
      @appointment_map[appt.local_date_time_slot.to_identifier] = appt
    end
    @trainer.appointments.where(clause).each do |appt|
      @appointment_map[appt.local_date_time_slot.to_identifier] = appt
    end


    #@appointment_map = appointments.inject({}) do |hash, appt|
    #  hash[appt.local_date_time_slot.to_identifier] = appt
    #  hash
    #end

  end

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

end
