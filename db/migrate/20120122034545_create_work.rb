class CreateWork < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table reporting.work (
        user_id integer not null references application.users deferrable,
        routine_id integer not null references application.routines deferrable,
        activity_id integer not null references application.activities deferrable,
        measurement_id integer not null references application.measurements deferrable,
        unit_set_id integer not null references application.unit_sets deferrable,
        start_time timestamptz not null,
        end_time timestamptz not null,
        start_day_id integer not null references reporting.days(day_id) deferrable,
        primary key (user_id, start_day_id, routine_id, activity_id, measurement_id, start_time, end_time)
      );

      grant select on reporting.work to reader;
      grant delete, insert, update on reporting.work to writer;

      comment on table reporting.work is 'A running log of metrics achieved during the performance of activities.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table reporting.work;
    OES
  end
  
  
end
