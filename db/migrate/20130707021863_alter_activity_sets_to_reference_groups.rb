class AlterActivitySetsToReferenceGroups < ActiveRecord::Migration
  def up
    execute <<-EOS
      alter table application.users alter city_id set default 0;

      alter table application.activity_sets
        add column activity_set_group_id integer not null default 0 references
        application.activity_set_groups(activity_set_group_id) deferrable;

      alter table application.activity_sets add column created_at timestamptz not null default now();
    EOS
  end

  def down
    execute <<-OES
      alter table application.activity_sets drop column activity_set_group_id;
      alter table application.activity_sets drop column created_at;
      alter table application.users alter city_id set default 685;
    OES
  end
end
