class CreateActivitySetGroups < ActiveRecord::Migration
  def up
    execute <<-EOS
      create table application.activity_set_groups (
        activity_set_group_id serial primary key,
        name text not null default 'Group of Sets',
        routine_id integer not null references application.routines(routine_id) deferrable,
        sets integer not null default 1,
        created_at timestamptz not null default now()
      );

      insert into application.users (user_id, login, first_name, last_name, email, password_digest)
        values (0, 'None', 'None', 'None', 'noone@ironoctop.us',
                '$2a$10$YZ2.QsL4Bn7TX0VsRKxvMeAyIbsnCdeYjYKi2bYg2jJmAnWqAxcD6');

      insert into application.routines (routine_id, name, permalink, client_id, trainer_id)
        values (0, 'None', 'none', 0, 0);

      insert into application.activity_set_groups (activity_set_group_id, routine_id, name)
        values (0, 0, 'None');

      alter table application.activity_sets
        add column activity_set_group_id integer not null default 0 references
        application.activity_set_groups(activity_set_group_id) deferrable;

      alter table application.activity_sets add column created_at timestamptz not null default now();

      grant select on application.activity_set_groups to reader;
      grant update, delete, insert on application.activity_set_groups to writer;

      grant select, update, usage on application.activity_set_groups_activity_set_group_id_seq to writer;

      comment on table application.activity_set_groups is 'Groups activity sets into common notions like supersets and circuits';
    EOS
  end

  def down
    execute <<-OES
      alter table application.activity_sets drop column activity_set_group_id;
      alter table application.activity_sets drop column created_at;
      drop table application.activity_set_groups;
      delete from application.routines where routine_id = 0;
      delete from application.users where user_id = 0;
    OES
  end
end
