class IndexRoutineHierarchy < ActiveRecord::Migration
  def up
    execute <<-EOS
      create index on application.activity_set_groups(routine_id);
      create index on application.activity_sets(activity_set_group_id);
      create index on application.activity_sets(measurement_id);
      create index on application.activity_sets(activity_id);
    EOS
  end

  def down
    execute <<-EOS
      drop index application.activity_set_groups_routine_id_idx;
      drop index application.activity_sets_activity_set_group_id_idx;
      drop index application.activity_sets_measurement_id_idx;
      drop index application.activity_sets_activity_id_idx;
    EOS
  end
end
