class CreateRecurringAppointmentRules < ActiveRecord::Migration

  def up
    execute <<-EOS
      create type timerange as range (
        subtype = time
      );

      create domain application.day_of_week as text check (value in ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'));

      create table application.recurring_appointment_rules (
        trainer_id integer not null references application.users(user_id) deferrable,
        client_id integer not null references application.users(user_id) deferrable,
        day_of_week day_of_week not null default 'Monday',
        time_slot timerange not null default '[8:00:00,9:00:00)',
        created_at timestamptz not null default now(),
        exclude using gist (trainer_id with =, day_of_week with =, time_slot WITH &&),
        exclude using gist (client_id with =, day_of_week with =, time_slot WITH &&),
        primary key (trainer_id, day_of_week, time_slot)
      );

      comment on table application.recurring_appointment_rules is 'Contains days of the week and time slots that recur weekly';

      grant select on application.recurring_appointment_rules to reader;
      grant insert, update, delete on application.recurring_appointment_rules to writer;
    EOS
  end

  def down
    execute <<-EOS
      drop table application.recurring_appointment_rules;
      drop type timerange;
      drop domain application.day_of_week;
    EOS
  end
end

