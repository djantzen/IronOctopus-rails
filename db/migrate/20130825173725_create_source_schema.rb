class CreateSourceSchema < ActiveRecord::Migration
  def up
    execute <<-EOS
      create schema source;
      comment on schema source is 'Data import schema';
      grant usage on schema source to writer, reader;
      alter role application set search_path=application,reporting,source,public;
      alter role reporter set search_path=reporting,application,source,public;
      alter role administrator set search_path=application,reporting,source,public;
    EOS
  end

  def down
    execute <<-EOS
      drop schema source;
      alter role application set search_path=application,reporting,public;
      alter role reporter set search_path=reporting,application,public;
      alter role administrator set search_path=application,reporting,public;
    EOS
  end
end
