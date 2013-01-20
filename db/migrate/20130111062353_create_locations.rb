class CreateLocations < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create table application.locations (
        location_id serial primary key,
        name text not null,
        street_address text not null,
        city_id integer not null references cities deferrable,
        postal_code text not null,
        category text not null default 'Athletic Club',
        permalink text not null,
        longitude decimal not null,
        latitude decimal not null,
        the_geom geometry(POINT, 4269),
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
      );

      create index on application.locations using gist(the_geom);
      create unique index on application.locations(permalink);
      create unique index on application.locations(name, street_address, city_id);

      grant select on application.locations to reader;
      grant delete, insert, update on application.locations to writer;

      grant select, usage, update on application.locations_location_id_seq to writer;

      comment on table application.locations is 'A table of clubs, dojos, studios, etc';
    OES
  end

  def self.down
    execute <<-OES
      drop table application.locations;
    OES
  end
end
