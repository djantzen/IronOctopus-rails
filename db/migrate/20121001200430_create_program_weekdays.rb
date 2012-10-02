class CreateProgramWeekdays < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.program_weekdays (
        routine_id integer not null,
        program_id integer not null,
        days_of_week integer not null default 0 check (days_of_week between 0 and 127),
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now(),
        primary key(routine_id, program_id),
        constraint days_of_week_fkey_routines_programs foreign key (routine_id, program_id)
          references application.routines_programs (routine_id, program_id) deferrable
      );

      grant select on application.program_weekdays to reader;
      grant delete, insert, update on application.program_weekdays to writer;

      comment on table application.program_weekdays is 'A table mapping days_of_week bytes to programs';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.program_weekdays;
    OES
  end
end
