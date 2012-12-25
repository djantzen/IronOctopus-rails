class CreateNeighborhoods < ActiveRecord::Migration
  def up
    execute <<-OES
      create table application.neighborhoods (
        neighborhood_id serial primary key,
        name text not null,
        city_id integer not null references application.cities deferrable,
        state_id integer not null references application.states deferrable,
        the_geom geometry not null,
        created_at timestamptz not null default now()
      );

      grant select on application.neighborhoods to reader;
      grant delete, insert, update on application.neighborhoods to writer;
      grant select, update, usage on application.neighborhoods_neighborhood_id_seq to writer;

      comment on table application.neighborhoods is 'A table of authoritative neighborhood records';
    OES
  end

  def down
    execute <<-OES
      drop table application.neighborhoods;
    OES
  end
end
