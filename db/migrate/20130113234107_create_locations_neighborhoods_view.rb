class CreateLocationsNeighborhoodsView < ActiveRecord::Migration
  def self.up
    execute <<-OES
      create index neighborhoods_st_envelope_idx on neighborhoods using gist(st_envelope(the_geom));
      comment on index neighborhoods_st_envelope_idx is 'A bounding box index for neighboring neighborhoods';

      create view application.locations_neighborhoods as
        select l.location_id, n2.neighborhood_id
          from locations l
            join neighborhoods n1 on
            st_within(l.the_geom, n1.the_geom)
            join neighborhoods n2 on
            st_intersects(st_envelope(n1.the_geom), st_envelope(n2.the_geom));

      grant select on application.locations_neighborhoods to reader;
    OES
  end

  def self.down
    execute <<-OES
      drop index neighborhoods_st_envelope_idx;
      drop view application.locations_neighborhoods;
    OES
  end
end
