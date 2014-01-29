class CreateAppointmentsRoutinesView < ActiveRecord::Migration
  def up
    execute <<-EOS
      create view application.appointments_routines as
        select
          appointment_id
        , routine_id
        from appointments
          join routines using(client_id)
          join scheduled_programs using(routine_id)
        where date_time_slot <@ tstzrange(scheduled_on, scheduled_on + interval '1 day');

        grant select on application.appointments_routines to reader;
    EOS
  end

  def down
    execute <<-EOS
      drop view application.appointments_routines;
    EOS
  end
end
