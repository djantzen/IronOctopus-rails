class CreateUnits < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.units (
        unit_id serial primary key,
        name text not null,
        abbr text not null,
        is_metric boolean not null default false,
        metric_id integer not null references application.metrics deferrable
      );

      create unique index on application.units (name);
      create unique index on application.units (abbr);

      grant select on application.units to reader;
      grant delete, insert, update on application.units to writer;
      grant select, update, usage on application.units_unit_id_seq to writer;

      comment on table application.units is 'Units associated with an activity set.';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.units;
    OES
  end

end
