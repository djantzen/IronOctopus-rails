class CreateRecurringRoutineRules < ActiveRecord::Migration
  def up
    execute <<-EOS
      create table application.recurring_routine_rules (
        routine_id integer not null references application.routines deferrable,
        day_of_week day_of_week not null default 'Monday',
        time_slot timerange not null default '[8:00:00, 9:00:00)',
        created_at timestamptz not null default now(),
        exclude using gist (routine_id with =, day_of_week with =, time_slot WITH &&),
        primary key (routine_id, day_of_week, time_slot)
      );
      comment on table application.recurring_routine_rules is 'Contains routines and the days of the week and time slots when they recur';

      grant select on application.recurring_routine_rules to reader;
      grant insert, update, delete on application.recurring_routine_rules to writer;
    EOS
  end

  def down
    execute <<-EOS
      drop table application.recurring_routine_rules;
    EOS
  end
end
