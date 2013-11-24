class CreateAppointments < ActiveRecord::Migration
  def up
    execute <<-EOS
      create table application.appointments(
        appointment_id serial primary key,
        trainer_id integer not null references application.users(user_id) deferrable,
        client_id integer not null references application.users(user_id) deferrable,
        time_slot tstzrange not null,
        created_at timestamptz not null default now()
      );
      comment on table application.appointments is 'Records the time range that a trainer is scheduled to meet with a client';
      grant select, usage, update on application.appointments_appointment_id_seq to writer;
      grant select on application.appointments to reader;
      grant insert, update, delete on application.appointments to writer;
      create unique index on application.appointments (trainer_id, client_id, time_slot);
      create unique index on application.appointments (time_slot);
    EOS
  end

  def down
    execute <<-EOS
      drop table application.appointments;
    EOS
  end
end
