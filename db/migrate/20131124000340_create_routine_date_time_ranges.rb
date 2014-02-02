class CreateRoutineDateTimeRanges < ActiveRecord::Migration
  def up
    execute <<-EOS
      create table application.routine_date_time_slots (
        routine_id integer not null references application.routines deferrable,
        date_time_slot tstzrange not null default ('[' || now()::date || ' 08:00:00,' || now()::date || ' 09:00:00)')::tstzrange,
        created_at timestamptz not null default now(),
        exclude using gist (routine_id with =, date_time_slot with &&),
        primary key(routine_id, date_time_slot)
      );

      comment on table application.routine_date_time_slots is 'Records the time range that a trainer is scheduled to meet with a client';

      grant select on application.routine_date_time_slots to reader;
      grant insert, update, delete on application.routine_date_time_slots to writer;
    EOS
  end

  def down
    execute <<-EOS
      drop table application.routine_date_time_slots;
    EOS
  end
end
