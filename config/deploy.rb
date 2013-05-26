require "rvm/capistrano"
require "bundler/capistrano"

set :application, "Iron Octopus"
set :repository,  "git@github.com:djantzen/IronOctopus-rails.git"
set :deploy_to, "/var/www"
set :scm, :git

set :bundle_without, [:development, :test]
set :rvm_install_ruby_params, '--1.9'
set :rvm_ruby_string, "ruby-1.9.3-p392@IronOctopus"
set :rvm_type, :system
set :rvm_bin_path, "/usr/local/rvm/bin"

qa_server = "ec2-54-214-179-20.us-west-2.compute.amazonaws.com"

set(:host_env, Capistrano::CLI.ui.ask("Host Environment (prod, qa): "))
set(:host, host_env.eql?('prod') ? 'ironoctop.us' : qa_server)

role :deploy, host #'ironoctop.us'
role :web, host # Your HTTP server, Apache/etc
role :app, host  # This may be the same as your `Web` server
role :db, host, :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

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

namespace :database do
  desc "backup the database and pull it down"
  task :backup do
    today = "#{Date.today.year}#{Date.today.month}#{Date.today.day}"
    filename = "iron_octopus_#{today}.sql"
    run "sudo su postgres -c 'pg_dump iron_octopus > /tmp/iron_octopus_#{today}.sql'"
    run "tar czf /tmp/#{filename}.tgz /tmp/#{filename}"
    download "/tmp/#{filename}.tgz", "/tmp/#{filename}.tgz"
  end
end

namespace :bundle do

  desc "run bundle install and ensure all gem requirements are met"
  task :install do
    run "bundle install --gemfile #{release_path}/Gemfile --without development test"
  end

end

before "deploy:setup", "rvm:install_rvm"   # install RVM
before "deploy:setup", "rvm:install_ruby"  # install Ruby and create gemset, or:
before "deploy:setup", "rvm:create_gemset" # only create gemset

after "deploy:update_code", "deploy:set_email_password"
after "deploy:update_code", "deploy:set_database_passwords"
after "deploy:set_database_passwords", "deploy:migrate_production"
after "deploy:restart", "deploy:cleanup"

# Uncomment if you are using Rails' asset pipeline
load 'deploy/assets'
