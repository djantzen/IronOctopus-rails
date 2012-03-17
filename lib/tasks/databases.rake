Rake.application.instance_variable_get('@tasks').delete('db:test:prepare')

namespace :db do
  namespace :structure do
    desc "Dump the database structure to a SQL file"
    task :dump => :load_config do
      puts "in dump"
#      config = ActiveRecord::Base.configurations[Rails.env]

#      command = "mysqldump -u #{config["username"]} #{config["database"]} --no-data --skip-comments --skip-add-drop-table > db/#{Rails.env}_structure.sql"
#      puts "Running: #{command}"
#      system command

#      command = "mysqldump -u #{config["username"]} #{config["database"]} --skip-extended-insert --no-create-info --skip-comments --tables schema_migrations >> db/#{Rails.env}_structure.sql"
#      puts "Running: #{command}"
#      system command
    end
  end
end


namespace :db do
  namespace :test do
    desc "Load the test database from a SQL file"
    task :prepare => "db:load_config" do
      puts "in prepare"
#      config = ActiveRecord::Base.configurations["test"]

#      command = "mysqladmin -u #{config["username"]} drop -f #{config["database"]}"
#      puts "Running: #{command}"
#      system command

#      command = "mysqladmin -u #{config["username"]} create #{config["database"]}"
#      puts "Running: #{command}"
#      system command

#      command = "mysql -u #{config["username"]} #{config["database"]} < db/development_structure.sql"
#      puts "Running: #{command}"
#      system command
    end
  end
end