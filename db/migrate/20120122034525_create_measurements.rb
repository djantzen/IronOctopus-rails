class CreateMeasurements < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.measurements (
        measurement_id serial primary key,
        duration real not null default 0,
        resistance real not null default 0,
        repetitions real not null default 1,
        pace real not null default 0,
        distance real not null default 0,
        calories integer not null default 0,
        distance_unit_id integer not null default 0 references application.units (unit_id),
        resistance_unit_id integer not null default 0 references application.units (unit_id),
        pace_unit_id integer not null default 0 references application.units (unit_id),
        created_at timestamptz not null default now()
      );
      create unique index measurement_uniq_idx on application.measurements (
        duration, resistance, repetitions, pace, distance, calories,
        distance_unit_id, resistance_unit_id, pace_unit_id);
      
      grant select on application.measurements to reporter;
      grant delete, insert, select, update on application.measurements to application;
      grant usage on application.measurements_measurement_id_seq to application;
      
      comment on table application.measurements is 'Measures associated with a set or work record.';
      comment on column application.measurements.duration is 'In seconds.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.measurements;
    OES
  end
  
  
end
