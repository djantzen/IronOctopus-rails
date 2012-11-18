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

def sed(file, target, replacement)
  run "cd #{release_path} && sed -i 's|password: #{target}|password: #{replacement}|' #{file}"
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Set email password"
  task :set_email_password, :roles => :app do
    set(:email_password, Capistrano::CLI.ui.ask("Email password: "))
    sed('config/email.yml', 'EMAIL_PASSWORD', fetch(:email_password))
  end

  desc "Set database passwords"
  task :set_database_passwords, :roles => :app do
    set(:admin_password, Capistrano::CLI.ui.ask("Administrator password: "))
    set(:application_password, Capistrano::CLI.ui.ask("Application password: "))
    sed('config/database.yml', 'ADMIN_PASSWORD', fetch(:admin_password))
    sed('config/database.yml', 'APPLICATION_PASSWORD', fetch(:application_password))
  end

  desc "Run migrations with admin permissions"
  task :migrate_production, :roles => :app do
    set(:rails_env, "migrate_production")
    migrate
    set(:rails_env, "production")
  end
end

namespace :bundle do

  desc "run bundle install and ensure all gem requirements are met"
  task :install do
    run "cd #{release_path} && sudo bundle install"
  end

end

after "deploy:update_code", "bundle:install"
after "deploy:update_code", "deploy:set_database_passwords"
after "deploy:set_database_passwords", "deploy:migrate_production"
after "deploy:update_code", "deploy:set_email_password"

# Uncomment if you are using Rails' asset pipeline
load 'deploy/assets'
