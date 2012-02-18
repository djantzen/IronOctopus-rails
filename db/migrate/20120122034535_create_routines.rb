class CreateRoutines < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.routines (
        routine_id serial primary key,
        name text not null default 'Routine',
        owner_id integer not null references application.users (user_id),
        creator_id integer not null references application.users (user_id),
        goal text not null default 'None',
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      grant select on application.routines to reporter;
      grant delete, insert, select, update on application.routines to application;
      grant usage on application.routines_routine_id_seq to application;

      create unique index routines_uniq_idx_owner_name on application.routines (owner_id, lower(name));

      comment on table application.routines is 'A grouping of activity sets that may be assigned to a user.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.routines;
    OES
  end
  
  
end
