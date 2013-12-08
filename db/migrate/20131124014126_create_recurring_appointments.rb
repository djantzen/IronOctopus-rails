class CreateRecurringAppointments < ActiveRecord::Migration

  def up
    execute <<-EOS
      create type timerange as range (
        subtype = time
      );

      create table application.recurring_appointments (
        trainer_id integer not null references application.users(user_id) deferrable,
        client_id integer not null references application.users(user_id) deferrable,
        day_of_week text not null default 'Monday' check
          (day_of_week in ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')),
        time_slot timerange not null,
        created_at timestamptz not null default now(),
        exclude using gist (trainer_id with =, day_of_week with =, time_slot WITH &&),
        exclude using gist (client_id with =, day_of_week with =, time_slot WITH &&),
        primary key (trainer_id, day_of_week, time_slot)
      );

      comment on table application.recurring_appointments is 'Contains days of the week and time slots that recur weekly';

      grant select on application.recurring_appointments to reader;
      grant insert, update, delete on application.recurring_appointments to writer;

    EOS
  end

  def down
    execute <<-EOS
      drop table application.recurring_appointments;
      drop type timerange;
    EOS
  end
end
