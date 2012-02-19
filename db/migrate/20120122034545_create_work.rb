class CreateWork < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table reporting.work (
        user_id integer not null references application.users,
        routine_id integer not null references application.routines,
        activity_id integer not null references application.activities,
        measurement_id integer not null references application.measurements,
        start_time timestamptz not null,
        end_time timestamptz not null,
        start_day_id integer not null references reporting.days,
        primary key (start_day_id, user_id, routine_id, activity_id, measurement_id, start_time, end_time)
      );

      grant select on reporting.work to reporter;
      grant insert, select on reporting.work to application;

      comment on table reporting.work is 'A running log of metrics achieved during the performance of activities.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table reporting.work;
    OES
  end
  
  
end
