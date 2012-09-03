class CreateRoutines < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.routines (
        routine_id serial primary key,
        name text not null,
        permalink text not null,
        trainer_id integer not null references application.users (user_id) deferrable,
        client_id integer not null references application.users (user_id) deferrable,
        has_been_sent boolean not null default false,
        goal text not null default 'Not specified',
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      grant select on application.routines to reader;
      grant delete, insert, update on application.routines to writer;
      grant select, update, usage on application.routines_routine_id_seq to writer;

      create unique index on application.routines (client_id, permalink);
      create index on application.routines (trainer_id);
      create index on application.routines (client_id);

      comment on table application.routines is 'A grouping of activity sets that may be assigned to a user.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.routines;
    OES
  end
  
  
end
