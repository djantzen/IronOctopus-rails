class CreateScheduledPrograms < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.scheduled_programs (
        routine_id integer not null references application.routines deferrable,
        program_id integer not null references application.programs deferrable,
        scheduled_at timestamptz not null,
        created_at timestamptz not null default now(),
        primary key(routine_id, program_id, scheduled_at)
      );

      grant select on application.scheduled_programs to reader;
      grant delete, insert, update on application.scheduled_programs to writer;

      comment on table application.scheduled_programs is 'A table mapping routines to programs at times';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.scheduled_programs;
    OES
  end
end
