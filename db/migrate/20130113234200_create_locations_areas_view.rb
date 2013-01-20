class CreateLocationsAreasView < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create view application.locations_areas as
      select location_id, area_id
        from application.locations, application.areas
        where st_within(locations.the_geom, areas.the_geom);
      grant select on application.locations_areas to reader;
    OES
  end

  def self.down
    execute <<-OES
      drop view application.locations_areas;
    OES
  end
end
