class CreateActivityImplements < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.activities_implements (
        activity_id integer not null references application.activities deferrable,
        implement_id integer not null references application.implements deferrable,
        created_at timestamptz not null default now(),
        primary key (activity_id, implement_id)
      );

      grant select on application.activities_implements to reporter;
      grant delete, insert, select, update on application.activities_implements to application;

      comment on table application.activities_implements is 'A mapping table joining activities to implements.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.activities_implements;
    OES
  end
end
