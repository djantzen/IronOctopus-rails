set :application, "Iron Octopus"
set :repository,  "git@github.com:djantzen/IronOctopus-rails.git"
set :deploy_to, "/var/www"
set :scm, :git

role :web, "ironoctop.us"                          # Your HTTP server, Apache/etc
role :app, "ironoctop.us"                          # This may be the same as your `Web` server
role :db,  "ironoctop.us", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

def sed(working_directory, file, target, replacement)
  run "cd #{working_directory} && sed -i 's|password: #{target}|password: #{replacement}|' #{file}"
end

namespace :deploy do
  desc "Set email password"
  task :set_email_password, :roles => :app do
    set(:email_password, Capistrano::CLI.ui.ask("Email password: ") { |q| q.echo = false })
    sed('/var/www/IronOctopus', 'config/email.yml', 'EMAIL_PASSWORD', fetch(:email_password))
  end

  desc "Set database passwords"
  task :set_database_passwords, :roles => :app do
    set(:admin_password, Capistrano::CLI.ui.ask("Administrator password: ") { |q| q.echo = false })
    set(:application_password, Capistrano::CLI.ui.ask("Application password: ") { |q| q.echo = false })
    sed('/var/www/IronOctopus', 'config/database.yml', 'ADMIN_PASSWORD', fetch(:admin_password))
    sed('/var/www/IronOctopus', 'config/database.yml', 'APPLICATION_PASSWORD', fetch(:application_password))
  end
end

after "deploy:update_code", "deploy:set_database_passwords"
after "deploy:set_database_password" do
  ENV['RAILS_ENV']="migrate_production"
  :migrate
end
after "deploy:update_code", "deploy:set_email_password"