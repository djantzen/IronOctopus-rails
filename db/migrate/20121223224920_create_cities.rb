class CreateCities < ActiveRecord::Migration
  def up
    execute <<-OES
      create table application.cities (
        city_id serial primary key,
        name text not null,
        state_id integer not null references application.states deferrable,
        population integer not null default 0,
        the_geom geometry not null,
        created_at timestamptz not null default now()
      );

      create index on application.cities using gist (the_geom);
      create index on application.cities (name, state_id);

      grant select on application.cities to reader;
      grant delete, insert, update on application.cities to writer;
      grant select, update, usage on application.cities_city_id_seq to writer;

      comment on table application.cities is 'A table of authoritative city records';
    OES
  end

  def down
    execute <<-OES
      drop table application.cities;
    OES
  end
end
