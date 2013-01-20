class CreateAreas < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.areas (
        area_id serial primary key,
        name text not null,
        permalink text not null,
        the_geom geometry(MULTIPOLYGON, 4269) not null,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      create index on application.areas using gist(the_geom);
      create unique index on application.areas(permalink);

      grant select on application.areas to reader;
      grant delete, insert, update on application.areas to writer;

      grant select, usage, update on application.areas_area_id_seq to writer;

      comment on table application.areas is 'A table of custom metropolitan areas such as Seattle';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.areas;
    OES
  end
end
