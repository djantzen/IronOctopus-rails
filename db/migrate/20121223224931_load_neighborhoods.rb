class LoadNeighborhoods < ActiveRecord::Migration
  def up
    data_source = File.open(Rails.root.to_s + "/db/scripts/init_neighborhoods.sql")
    data = data_source.read
    execute data
  end

  def down
    execute <<-OES
      delete from application.neighborhoods
      select pg_catalog.setval('neighborhoods_neighborhood_id_seq', 1, true);
    OES
  end
end
