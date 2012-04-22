class CreateActivities < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.activities (
        activity_id serial primary key,
        name text not null,
        instructions text not null default 'None',
        warnings text not null default 'None',
        activity_type_id integer not null references application.activity_types deferrable,
        creator_id integer not null references application.users (user_id) deferrable,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      create unique index activities_uniq_idx_name on application.activities (lower(regexp_replace(name, '\s', 'g')));
      
      grant select on application.activities to reporter;
      grant delete, insert, select, update on application.activities to application;
      grant select, update, usage on application.activities_activity_id_seq to application;

      comment on table application.activities is 'All activities or exercises available in the system e.g. ''Bench Press''';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.activities;
    OES
  end

end
