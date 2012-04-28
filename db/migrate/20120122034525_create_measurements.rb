class CreateMeasurements < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.measurements (
        measurement_id serial primary key,
        duration integer not null default 0,
        resistance real not null default 0,
        pace real not null default 0,
        distance real not null default 0,
        calories integer not null default 0,
        incline real not null default 0,
        created_at timestamptz not null default now()
      );
      create unique index measurement_uniq_idx on application.measurements (
        duration, resistance, pace, distance, calories, incline);
      
      grant select on application.measurements to reader;
      grant delete, insert, update on application.measurements to writer;
      grant select, update, usage on application.measurements_measurement_id_seq to writer;
      
      comment on table application.measurements is 'Measures associated with a set or work record.';
      comment on column application.measurements.duration is 'In seconds.';
      comment on column application.measurements.distance is 'In meters.';
      comment on column application.measurements.resistance is 'In kilograms.';
      comment on column application.measurements.pace is 'In kilometers per hour.';
      comment on column application.measurements.incline is 'In degrees.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.measurements;
    OES
  end
  
  
end
