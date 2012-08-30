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

      create unique index units_uniq_idx_name on application.units (name);
      create unique index units_uniq_idx_abbr on application.units (abbr);

      grant select on application.units to reader;

      comment on table application.units is 'Units associated with an activity set.';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.units;
    OES
  end

end
