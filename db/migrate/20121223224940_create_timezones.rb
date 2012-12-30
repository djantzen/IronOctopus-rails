class CreateTimezones < ActiveRecord::Migration
  def up
    execute <<-OES
      create table application.timezones (
        timezone_id serial primary key,
        tzid text not null,
        the_geom geometry(MultiPolygon, 4269),
        created_at timestamptz not null default now()
      );

      create index on application.timezones using gist (the_geom);
      create unique index on application.timezones (tzid);

      grant select on application.timezones to reader;
      grant delete, insert, update on application.timezones to writer;
      grant select, update, usage on application.timezones_timezone_id_seq to writer;

      comment on table application.timezones is 'A table of authoritative timezone records';
    OES
  end

  def down
    execute <<-OES
      drop table application.timezones;
    OES
  end
end
