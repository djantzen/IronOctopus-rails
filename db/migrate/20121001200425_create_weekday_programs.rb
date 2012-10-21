class CreateWeekdayPrograms < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.weekday_programs (
        routine_id integer not null references application.routines deferrable,
        program_id integer not null references application.programs deferrable,
        day_of_week text not null default 'Monday' check (day_of_week in ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')),
        meridian text not null default 'AM' check(meridian in ('AM', 'PM')),
        created_at timestamptz not null default now(),
        primary key(routine_id, program_id, day_of_week, meridian)
      );

      grant select on application.weekday_programs to reader;
      grant delete, insert, update on application.weekday_programs to writer;

      comment on table application.weekday_programs is 'A table mapping routines to programs and days of week';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.weekday_programs;
    OES
  end
end
