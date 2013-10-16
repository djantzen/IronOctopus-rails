class CreateAlternateActivityNames < ActiveRecord::Migration
  def up
    execute <<-EOS
      create table application.alternate_activity_names
      (
        activity_id integer not null references application.activities(activity_id) deferrable,
        name text not null default '',
        permalink text not null default '',
        created_at timestamptz not null default now()
      );

      create unique index on application.alternate_activity_names(permalink);
      comment on table application.alternate_activity_names is 'Acceptable variations of the activity''s primary name, such as RDL for Romanian Deadlift';
      grant select on application.alternate_activity_names to reader;
      grant insert, update, delete on application.alternate_activity_names to writer;
    EOS
  end

  def down
    execute <<-EOS
      drop table application.alternate_activity_names;
    EOS
  end
end
