class CreateAppointmentRoutinesView < ActiveRecord::Migration
  def up
    execute <<-EOS
      create view application.appointment_routines as
        select
          appointment_id
        , routines.routine_id
        from appointments
          join routines using(trainer_id, client_id)
          join routine_date_time_slots using(routine_id, date_time_slot);

        grant select on application.appointment_routines to reader;
    EOS
  end

  def down
    execute <<-EOS
      drop view application.appointment_routines;
    EOS
  end
end
