class RecurringAppointmentRulesController < ApplicationController

  def create
    time_slot = SimpleTimeRange.from_identifier(params[:recurring_appointment_rule][:time_slot_id])
    weekday = params[:recurring_appointment_rule][:day_of_week]
    trainer = User.find_by_login(params[:user_id])
    client = User.find_by_login(params[:recurring_appointment_rule][:client_login])
    RecurringAppointmentRule.create(:trainer => trainer, :client => client, :time_slot => time_slot, :day_of_week => weekday)
  end

  def destroy
    time_slot = SimpleTimeRange.from_identifier(params[:time_slot_id])
    weekday = params[:day_of_week]
    trainer = User.find_by_login(params[:user_id])
    RecurringAppointmentRule.delete_all(:trainer_id => trainer.user_id, :time_slot => time_slot.to_query, :day_of_week => weekday)
  end

  def update
    trainer = User.find_by_login(params[:user_id])
    day_of_week = params[:day_of_week]
    time_slot = SimpleTimeRange.from_identifier(params[:time_slot_id])

    new_time_slot = SimpleTimeRange.from_identifier(params[:recurring_appointment_rule][:time_slot_id])
    new_day_of_week = params[:recurring_appointment_rule][:day_of_week]
    client = User.find_by_login(params[:recurring_appointment_rule][:client_login])

    RecurringAppointmentRule.transaction do
      RecurringAppointmentRule.delete_all(:trainer_id => trainer.id, :day_of_week => day_of_week,
                                          :time_slot => time_slot.to_query)

      RecurringAppointmentRule.create(:trainer => trainer, :client => client, :time_slot => new_time_slot,
                                      :day_of_week => new_day_of_week)
    end
  end

end