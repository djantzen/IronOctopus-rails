class CreateMeasurements < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.measurements (
        measurement_id serial primary key,
        cadence decimal not null default 0 check(cadence between 0 and 200),
        calories integer not null default 0 check(calories between 0 and 5000),
        distance decimal not null default 0 check(distance between 0 and 42000),
        duration integer not null default 0 check(duration between 0 and 86400),
        incline decimal not null default 0 check(incline between 0 and 20),
        level integer not null default 0 check(level between 0 and 20),
        resistance decimal not null default 0 check(resistance between 0 and 500),
        speed decimal not null default 0 check(speed between 0 and 100),
        created_at timestamptz not null default now()
      );
      create unique index on application.measurements (
        cadence, calories, distance, duration, incline, level, resistance, speed);
      
      grant select on application.measurements to reader;
      grant delete, insert, update on application.measurements to writer;
      grant select, update, usage on application.measurements_measurement_id_seq to writer;
      
      comment on table application.measurements is 'Measures associated with a set or work record.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.measurements;
    OES
  end
  
  
end
