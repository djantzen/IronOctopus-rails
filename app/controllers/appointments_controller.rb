class AppointmentsController < ApplicationController
  def create
    @trainer = User.find_by_login(params[:user_id])
    @client = User.find_by_login(params[:appointment][:client_login])
    @date_time_slot_id = params[:appointment][:date_time_slot_id]
    @date_time_slot = DateTimeRange.from_identifier(@date_time_slot_id)
    @routine_select =  @client.routines.map { |r| [r.name, r.permalink] }
    @appointment = Appointment.new(:trainer => @trainer, :client => @client, :date_time_slot => @date_time_slot)
    @appointment.save
  end

  def destroy
    trainer = User.find_by_login(params[:user_id])
    @date_time_slot_id = params[:id]
    date_time_slot = DateTimeRange.from_identifier(@date_time_slot_id)
    Appointment.delete_all(:trainer_id => trainer.id, :date_time_slot => date_time_slot.to_query)
  end
end
