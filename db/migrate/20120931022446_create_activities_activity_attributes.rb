class CreateActivitiesActivityAttributes < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.activities_activity_attributes (
        activity_id integer not null references application.activities deferrable,
        activity_attribute_id integer not null references application.activity_attributes deferrable,
        created_at timestamptz not null default now(),
        primary key (activity_id, activity_attribute_id)
      );

      grant select on application.activities_activity_attributes to reader;
      grant delete, insert, update on application.activities_activity_attributes to writer;

      comment on table application.activities_activity_attributes is 'A mapping table from activities to activity attributes';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.activities_activity_attributes;
    OES
  end

end
