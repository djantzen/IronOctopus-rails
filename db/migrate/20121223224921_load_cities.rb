class LoadCities < ActiveRecord::Migration
  def up
    data_source = File.open(Rails.root.to_s + "/db/scripts/init_cities.sql")
    data = data_source.read
    execute data
  end

  def down
    execute <<-OES
      truncate application.cities;
      select pg_catalog.setval('cities_city_id_seq', 1, true);
    OES
  end
end
