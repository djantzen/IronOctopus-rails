class AppointmentsController < ApplicationController
  def create
    @trainer = User.find_by_login(params[:user_id])
    @client = User.find_by_login(params[:appointment][:client_login])
    @date_time_slot_id = params[:appointment][:date_time_slot_id]
    @date_time_slot = DateTimeRange.from_identifier(@date_time_slot_id)
    Appointment.transaction do
      @appointment = Appointment.new(:trainer => @trainer, :client => @client, :date_time_slot => @date_time_slot)
      @appointment.save
    end
  end

  def update
    trainer = User.find_by_login(params[:user_id])
    @date_time_slot_id = params[:id]
    @new_date_time_slot_id = params[:appointment][:date_time_slot_id]
    client = User.find_by_login(params[:appointment][:client_login])
    date_time_slot = DateTimeRange.from_identifier(@date_time_slot_id)
    new_date_time_slot = DateTimeRange.from_identifier(@new_date_time_slot_id)
    appointment = Appointment.where(:trainer_id => trainer.id, :client_id => client.id,
                                    :date_time_slot => date_time_slot.to_query).first
    appointment.date_time_slot = new_date_time_slot
    appointment.client = client
    appointment.save
  end

  def destroy
    trainer = User.find_by_login(params[:user_id])
    @date_time_slot_id = params[:id]
    date_time_slot = DateTimeRange.from_identifier(@date_time_slot_id)
    appointment = Appointment.where(:trainer_id => trainer.id, :date_time_slot => date_time_slot.to_query).first
    if appointment.routine && appointment.routine.routine_date_time_slots.size == 1 # if this is the only usage of the routine
      appointment.routine.destroy # get rid of all dependent objects
    end
    appointment.delete
  end
end
