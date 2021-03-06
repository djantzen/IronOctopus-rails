class InitDatabaseSchemas < ActiveRecord::Migration
  def up
    execute <<-EOS
      create schema application;
      create schema reporting;

      comment on schema application is 'Operational schema.';
      comment on schema reporting is 'Reporting and analysis schema.';

      grant usage on schema application to application, reporter;
      grant usage on schema reporting to application, reporter;

      alter role application set search_path=application,reporting,public;
      alter role reporter set search_path=reporting,application,public;
      alter role administrator set search_path=application,reporting,public;
      
      grant select on public.schema_migrations to application;
    EOS
  end

  def down
    execute <<-EOS
      revoke select on public.schema_migrations from application;
    
      alter role administrator set search_path=public;
      alter role application set search_path=public;
      alter role reporter set search_path=public;

      drop schema application;
      drop schema reporting;
    EOS
  end
end
