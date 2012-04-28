class CreateRoutines < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.routines (
        routine_id serial primary key,
        name text not null default 'Routine',
        trainer_id integer not null references application.users (user_id) deferrable,
        owner_id integer not null references application.users (user_id) deferrable,
        client_id integer not null references application.users (user_id) deferrable,
        goal text not null default 'None',
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      grant select on application.routines to reader;
      grant delete, insert, update on application.routines to writer;
      grant select, update, usage on application.routines_routine_id_seq to writer;

      create unique index routines_uniq_idx_owner_name on application.routines (owner_id, lower(regexp_replace(name, '\s', 'g')));
      create index routines_idx_trainer on application.routines (trainer_id);
      create index routines_idx_owner on application.routines (owner_id);
      create index routines_idx_client on application.routines (client_id);

      comment on table application.routines is 'A grouping of activity sets that may be assigned to a user.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.routines;
    OES
  end
  
  
end
