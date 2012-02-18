class CreateActivities < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.activities (
        activity_id serial primary key,
        name text not null,
        activity_type_id integer not null references application.activity_types,
        creator_id integer not null references application.users (user_id),
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      create unique index activities_uniq_idx_name on application.activities (lower(name));
      
      grant select on application.activities to reporter;
      grant delete, insert, select, update on application.activities to application;
      grant usage on application.activities_activity_id_seq to application;

      comment on table application.activities is 'All activities or exercises available in the system e.g. ''Bench Press''';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.activities;
    OES
  end

end
