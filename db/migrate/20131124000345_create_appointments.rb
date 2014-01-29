class CreateAppointments < ActiveRecord::Migration
  def up
    execute <<-EOS
      create table application.appointments(
        appointment_id serial primary key,
        trainer_id integer not null references application.users(user_id) deferrable,
        client_id integer not null references application.users(user_id) deferrable,
        date_time_slot tstzrange not null,
        confirmation_status text not null default 'Unconfirmed'
          check(confirmation_status in ('Confirmed', 'Pending',  'Rejected', 'Unconfirmed')),
        notes text not null default '',
        created_at timestamptz not null default now(),
        exclude using gist (trainer_id with =, date_time_slot with &&),
        exclude using gist (client_id with =, date_time_slot with &&),
        unique (trainer_id, date_time_slot)
      );

      comment on table application.appointments is 'Records the time range that a trainer is scheduled to meet with a client';
      comment on column application.appointments.confirmation_status is 'A new appointment is Unconfirmed; when an email is sent it is Pending; it can be Confirmed or Rejected';

      grant select on application.appointments to reader;
      grant insert, update, delete on application.appointments to writer;
      grant usage, select, update on sequence application.appointments_appointment_id_seq to writer;
    EOS
  end

  def down
    execute <<-EOS
      drop table application.appointments;
    EOS
  end
end
