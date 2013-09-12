class SimplifyWorkTimes < ActiveRecord::Migration
  def up
    execute <<-EOS
      alter table reporting.work drop constraint work_pkey;
      alter table reporting.work drop column end_time;
      alter table reporting.work rename column start_day_id to day_id;
      alter table reporting.work add primary key
        (user_id, day_id, routine_id, activity_id, measurement_id, start_time);
    EOS
  end

  def down
    execute <<-EOS
      alter table reporting.work drop constraint work_pkey;
      alter table reporting.work add column end_time timestamptz not null default now();
      alter table reporting.work rename column day_id to start_day_id;
      alter table reporting.work add primary key
        (user_id, start_day_id, routine_id, activity_id, measurement_id, start_time, end_time);
      update reporting.work set end_time = start_time;
    EOS
  end
end
