class AlterActivitySetsToReferenceGroups < ActiveRecord::Migration
  def up
    execute <<-EOS
      alter table application.activity_sets
        add column activity_set_group_id integer references
        application.activity_set_groups(activity_set_group_id) deferrable;
    EOS

    ActivitySet.all.each do |set|
      execute <<-EOS
        insert into application.activity_set_groups (routine_id) values (#{set.routine_id});

        update application.activity_sets set activity_set_group_id =
        (select max(activity_set_group_id) from application.activity_set_groups)
        where routine_id = #{set.routine_id} and position = #{set.position}
      EOS
    end

    execute <<-EOS
      alter table application.activity_sets alter column activity_set_group_id set not null;
      alter table application.activity_sets drop column routine_id;
      alter table application.activity_sets add primary key (activity_set_group_id, position);
      alter table application.activity_sets add column created_at timestamptz not null default now();
      alter table application.activity_sets drop column optional;
    EOS

  end

  def down
    execute <<-OES
      alter table application.activity_sets add column routine_id integer references routines(routine_id) deferrable;
    OES

    ActivitySetGroup.all.each do |group|
      group.activity_sets.each do |set|
        execute <<-EOS
          update application.activity_sets set routine_id = #{group.routine_id}
          where activity_set_group_id = #{group.activity_set_group_id}
        EOS
      end
    end

    execute <<-OES
      alter table application.activity_sets drop column activity_set_group_id;
      delete from application.activity_set_groups;
      alter table application.activity_sets alter column routine_id set not null;
      alter table application.activity_sets drop column activity_set_id;
      alter table application.activity_sets add primary key (routine_id, position);
      alter table application.activity_sets drop column created_at;
      alter table application.activity_sets add column optional boolean not null default false;
    OES
  end
end
