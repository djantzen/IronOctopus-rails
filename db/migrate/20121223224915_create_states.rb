class CreateStates < ActiveRecord::Migration
  def up
    execute <<-OES
      create table application.states (
        state_id serial primary key,
        name text not null,
        abbr text not null,
        the_geom geometry not null,
        created_at timestamptz not null default now()
      );

      grant select on application.states to reader;
      grant delete, insert, update on application.states to writer;
      grant select, update, usage on application.states_state_id_seq to writer;

      comment on table application.states is 'A table of authoritative state/province records';
    OES
  end

  def down
    execute <<-OES
      drop table application.states;
    OES
  end
end
