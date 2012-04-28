class CreateImplements < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.implements (
        implement_id serial primary key,
        name text not null,
        category text not null default 'None',
        creator_id integer not null references application.users(user_id) deferrable,
        created_at timestamptz not null default now()
      );

      grant select on application.implements to reader;
      grant delete, insert, update on application.implements to writer;
      grant select, update, usage on application.implements_implement_id_seq to writer;

      create unique index implements_uniq_idx_name on application.implements (lower(regexp_replace(name, '\s', 'g')));

      comment on table application.implements is 'An implement to be utilized in the performance of an activity.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.implements;
    OES
  end
end
