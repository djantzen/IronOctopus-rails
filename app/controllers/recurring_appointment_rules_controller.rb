class RecurringAppointmentRulesController < ApplicationController

  def create
    date_time_slot = DateTimeRange.from_identifier(params[:recurring_appointment_rule][:date_time_slot_id])
    weekday = Weekday.from_day_of_week(date_time_slot.min.cwday)
    time_slot = SimpleTimeRange.new(SimpleTime.parse(date_time_slot.min.iso8601), SimpleTime.parse(date_time_slot.max.iso8601))
    trainer = User.find_by_login(params[:user_id])
    client = User.find_by_login(params[:recurring_appointment_rule][:client_login])
    RecurringAppointmentRule.create(:trainer => trainer, :client => client, :time_slot => time_slot, :day_of_week => weekday.name)
  end

  def destroy
    date_time_slot = DateTimeRange.from_identifier(params[:id])
    weekday = Weekday.from_day_of_week(date_time_slot.min.cwday)
    time_slot = SimpleTimeRange.new(SimpleTime.parse(date_time_slot.min.iso8601), SimpleTime.parse(date_time_slot.max.iso8601))
    trainer = User.find_by_login(params[:user_id])
    RecurringAppointmentRule.delete_all(:trainer_id => trainer.user_id, :time_slot => time_slot.to_query, :day_of_week => weekday.name)
  end

  def update
    @date_time_slot_id = params[:id]
    @new_date_time_slot_id = params[:new_date_time_slot_id]
    weekday = Weekday.from_day_of_week(date_time_slot.min.cwday)
    @date_time_slot = DateTimeRange.from_identifier(@date_time_slot_id)
    @new_date_time_slot = DateTimeRange.from_identifier(@new_date_time_slot_id)
    recurring_appointment_rule = RecurringAppointmentRule.where(:trainer_id => trainer.id, :day_of_week => weekday.day_of_week,
                                                                :date_time_slot => @date_time_slot.to_query).first
    recurring_appointment_rule.date_time_slot = @new_date_time_slot
    recurring_appointment_rule.day_of_week = weekday.day_of_week
    recurring_appointment_rule.save
  end

end