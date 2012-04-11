class CreateImplements < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.implements (
        implement_id serial primary key,
        name text not null,
        created_at timestamptz not null default now()
      );

      grant select on application.implements to reporter;
      grant delete, insert, select, update on application.implements to application;
      grant select, update, usage on application.implements_implement_id_seq to application;

      comment on table application.implements is 'An implement to be utilized in the performance of an activity.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.implements;
    OES
  end
end
