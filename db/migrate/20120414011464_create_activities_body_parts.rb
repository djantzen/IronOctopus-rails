class CreateActivitiesBodyParts < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.activities_body_parts (
        activity_id integer not null references application.activities deferrable,
        body_part_id integer not null references application.body_parts deferrable,
        created_at timestamptz not null default now(),
        primary key (activity_id, body_part_id)
      );

      grant select on application.activities_body_parts to reporter;
      grant delete, insert, select, update on application.activities_body_parts to application;

      comment on table application.activities_body_parts is 'A table mapping activities to body parts';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.activities_body_parts;
    OES
  end
end
