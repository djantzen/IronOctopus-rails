class CreatePrograms < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.programs (
        program_id serial primary key,
        name text not null,
        goal text not null,
        permalink text not null,
        trainer_id integer not null references application.users(user_id) deferrable,
        client_id integer not null references application.users(user_id) deferrable,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      grant select on application.programs to reader;
      grant delete, insert, update on application.programs to writer;
      grant select, update, usage on application.programs_program_id_seq to writer;

      create unique index on application.programs (client_id, permalink);
      create unique index on application.programs (trainer_id, permalink);

      comment on table application.programs is 'A table recording all programs in the system';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.programs;
    OES
  end
end
