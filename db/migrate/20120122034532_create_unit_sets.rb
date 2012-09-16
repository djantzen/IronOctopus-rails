class CreateUnitSets < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.unit_sets (
        unit_set_id serial primary key,
        cadence_unit_id integer not null references application.units deferrable,
        distance_unit_id integer not null references application.units deferrable,
        duration_unit_id integer not null references application.units deferrable,
        resistance_unit_id integer not null references application.units deferrable,
        speed_unit_id integer not null references application.units deferrable,
        created_at timestamptz not null default now()
      );

      create unique index on application.unit_sets (cadence_unit_id, distance_unit_id,
                                                    duration_unit_id, resistance_unit_id, speed_unit_id);

      grant select on application.unit_sets to reader;
      grant delete, insert, update on application.unit_sets to writer;
      grant select, update, usage on application.unit_sets_unit_set_id_seq to writer;

      comment on table application.unit_sets is 'Units associated with an activity set or work record.';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.unit_sets;
    OES
  end

end
