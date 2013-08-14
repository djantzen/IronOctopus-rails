class CreateActivitySetGroups < ActiveRecord::Migration
  def up
    execute <<-EOS
      create table application.activity_set_groups (
        activity_set_group_id serial primary key,
        name text not null default '',
        routine_id integer not null references application.routines(routine_id) deferrable,
        sets integer not null default 1,
        created_at timestamptz not null default now()
      );

      grant select on application.activity_set_groups to reader;
      grant update, delete, insert on application.activity_set_groups to writer;

      grant select, update, usage on application.activity_set_groups_activity_set_group_id_seq to writer;

      comment on table application.activity_set_groups is 'Groups activity sets into common notions like supersets and circuits';
    EOS
  end

  def down
    execute <<-OES
      drop table application.activity_set_groups;
    OES
  end
end
