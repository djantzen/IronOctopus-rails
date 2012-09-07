class CreateImplements < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.implements (
        implement_id serial primary key,
        name text not null,
        category text not null default 'None',
        permalink text not null,
        created_at timestamptz not null default now()
      );

      grant select on application.implements to reader;
      grant delete, insert, update on application.implements to writer;
      grant select, update, usage on application.implements_implement_id_seq to writer;

      create unique index on application.implements (permalink);

      comment on table application.implements is 'An implement to be utilized in the performance of an activity.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.implements;
    OES
  end
end
