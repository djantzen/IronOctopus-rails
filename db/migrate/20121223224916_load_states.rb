class LoadStates < ActiveRecord::Migration
  def up
    data_source = File.open(Rails.root.to_s + "/db/scripts/init_states.sql")
    data = data_source.read
    execute data
  end

  def down
    execute <<-OES
      truncate application.states;
      select pg_catalog.setval('states_state_id_seq', 1, true);
    OES
  end
end
