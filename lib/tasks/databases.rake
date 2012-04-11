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

require 'active_record/fixtures' 

namespace :db do 
  namespace :fixtures do 
    desc "Load fixtures into the current environment's database.  Load specific fixtures using FIXTURES=x,y" 
    task :loadx => :environment do
      ActiveRecord::Base.establish_connection(ENV['RAILS_ENV'].to_sym)
      
      fixtures = if ENV['FIXTURES'] then
        ENV['FIXTURES'].split(/,/)
      else
        Dir.glob('test/fixtures/*.{csv,yml}').map { |f| f.sub(/test\/fixtures\//, '').sub(/\.yml/, '') }
      end
      
      ActiveRecord::Fixtures.create_fixtures('test/fixtures', fixtures) 
    end 
  end 
end 