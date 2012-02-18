class CreateUnits < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table application.units (
        unit_id serial primary key,
        name text not null,
        abbr text not null
      );

      create unique index units_uniq_idx_name on application.units (lower(name));

      grant delete, insert, select, update on application.units to application;
      grant select on application.units to reporter;
      grant usage on application.units_unit_id_seq to application;

      comment on table application.units is 'Stores units of measure for modifying numeric values, e.g. ''Pound'', ''Kilogram'', ''Sock''';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table application.units;
    OES
  end
  
  
end
