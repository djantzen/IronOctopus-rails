class CreateActivities < ActiveRecord::Migration

def self.up
    execute <<-OES
      create table application.activities (
        activity_id serial primary key,
        name text not null,
        instructions text not null default 'None',
        warnings text not null default 'None',
        activity_type_id integer not null references application.activity_types deferrable,
        permalink text not null,
        creator_id integer not null references application.users (user_id) deferrable,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      create unique index on application.activities(permalink);

      grant select on application.activities to reader;
      grant delete, insert, update on application.activities to writer;
      grant select, update, usage on application.activities_activity_id_seq to writer;

      comment on table application.activities is 'All activities or exercises available in the system e.g. ''Bench Press''';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.activities;
    OES
  end

end
