class InitDatabaseRoles < ActiveRecord::Migration
  def up
    execute <<-EOS
      create user application with password 'application';
      comment on role application is 'Operational user for the application';
      grant application to administrator;
      create user reporter with password 'reporter';
      comment on role reporter is 'Read only user for building reports';
      grant reporter to administrator;
    EOS
  end

  def down
    execute <<-EOS
      drop user application;
      drop user reporter;
    EOS
  end
end
