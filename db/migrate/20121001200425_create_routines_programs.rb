class CreateRoutinesPrograms < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.routines_programs (
        routine_id integer not null references application.routines deferrable,
        program_id integer not null references application.programs deferrable,
        created_at timestamptz not null default now(),
        primary key(routine_id, program_id)
      );

      grant select on application.routines_programs to reader;
      grant delete, insert, update on application.routines_programs to writer;

      comment on table application.routines_programs is 'A table mapping routines to programs';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.routines_programs;
    OES
  end
end
