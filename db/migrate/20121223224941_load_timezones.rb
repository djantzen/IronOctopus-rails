class LoadTimezones < ActiveRecord::Migration
  def up
    data_source = File.open(Rails.root.to_s + "/db/scripts/init_timezones.sql")
    data = data_source.read
    execute data
  end

  def down
    execute <<-OES
      delete from application.timezones;
      select pg_catalog.setval('timezones_timezone_id_seq', 1, true);
    OES
  end
end
