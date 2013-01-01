class AddHeartRateToMeasures < ActiveRecord::Migration
  def up
    execute <<-OES
      alter table application.measurements add column heart_rate integer not null default 0 check(heart_rate between 0 and 200);
      drop index measures_uniq_idx_all;
      create unique index measures_uniq_idx_all on application.measurements (
        cadence, calories, distance, duration, heart_rate, incline, level, repetitions, resistance, speed
      );
      insert into application.metrics (name) values ('Heart Rate');
    OES
  end

  def down
    execute <<-OES
      drop index measures_uniq_idx_all;
      delete from application.metrics where name = 'Heart Rate';
      alter table application.measurements drop column heart_rate;
      create unique index measures_uniq_idx_all on application.measurements (
        cadence, calories, distance, duration, incline, level, repetitions, resistance, speed
      );
    OES
  end
end
