class AddPrescribedMeasurementToWork < ActiveRecord::Migration

  def self.up
    execute <<-OES
      alter table reporting.work add column prescribed_measurement_id integer not null default 0
        references application.measurements(measurement_id) deferrable;
      create index on reporting.work (prescribed_measurement_id);
    OES
  end

  def self.down
    execute <<-OES
      alter table application.work drop column prescribed_measurement_id;
    OES

  end

end
