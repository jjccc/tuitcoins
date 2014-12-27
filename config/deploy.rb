require "rvm/capistrano"
require "bundler/capistrano"

set :application, "tuitcoins"
set :deploy_to, "/home/tuitcoins"
set :repository,  "git@github.com:jjccc/tuitcoins.git"

set :scm, :git
default_run_options[:pty] = true
set :user, "root"
set :domain, "tuitcoins.com"
set :use_sudo, false

set :rvm_ruby_string, 'ruby-2-1-2'
set :rvm_type, :system
server '178.62.145.40', :app, :web, :primary => true
set :remote_host, '178.62.145.40'

# Setup Shared Folders that should be created inside the shared_path
directory_configuration = %w(db config system)

# Setup Symlinks that should be created after each deployment
symlink_configuration = [
    %w(config/database.yml config/database.yml)
]

# Application Specific Tasks
# that should be performed at the end of each deployment
def application_specific_tasks
  # system 'cap deploy:whenever:update_crontab'
  # system 'cap deploy:delayed_job:stop'
  # system 'cap deploy:delayed_job:start n=1'
  # system 'cap deploy:run_command command="ls -la"'
end





# =================================== #
# END CONFIGURATION #
# DON'T EDIT THE CONFIGURATION BELOW #
# =================================== #

#
# Helper Methods
#

def create_tmp_file(contents)
  system 'mkdir tmp'
  file = File.new("tmp/#{domain}", "w")
  file << contents
  file.close
end

#
# Capistrano Recipe
#
namespace :deploy do

  # Tasks that run after every deployment (cap deploy)

  desc "Initializes a bunch of tasks in order after the last deployment process."
  task :restart do
    puts "\n\n=== Running Custom Processes! ===\n\n"
    create_production_log
    setup_symlinks
    system 'cap deploy:passenger_restart'
    #puts "\n\n=== Running Application Specific Tasks! ===\n\n"
    #application_specific_tasks
    #set_permissions
  end

  # Deployment Tasks
  desc "Executes the initial procedures for deploying a Ruby on Rails Application."
  task :initial do
    system "cap deploy:setup"
    system "cap deploy"
    system "cap deploy:gems:install"
    system "cap deploy:db:create"
    system "cap deploy:db:migrate"
    system "cap deploy:passenger_restart"
  end

  desc "Restarts Passenger"
  task :passenger_restart,:roles => :app, :except => { :no_release => true } do
    puts "\n\n=== Restarting Passenger! ===\n\n"
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Creates the production log if it does not exist"
  task :create_production_log do
    unless File.exist?(File.join(shared_path, 'log', 'production.log'))
      puts "\n\n=== Creating Production Log! ===\n\n"
      run "touch #{File.join(shared_path, 'log', 'production.log')}"
    end
  end

  desc "Creates symbolic links from shared folder"
  task :setup_symlinks do
    puts "\n\n=== Setting up Symbolic Links! ===\n\n"
    symlink_configuration.each do |config|
      run "ln -nfs #{File.join(shared_path, config[0])} #{File.join(release_path, config[1])}"
    end
  end

  # Manual Tasks

  namespace :db do

    desc "Snapshots production db and dumps into local development db"
    task :pull, roles: :db, only: { primary: true } do
      # adjust prod_config to point to your database.yml
      #prod_config = capture "cat #{shared_path}/config/database.yml"

      #prod = YAML::parse(prod_config)["production"]
      prod = YAML::load_file("config/database.yml")["production"]
      dev  = YAML::load_file("config/database.yml")["development"]
      dump = "/tmp/#{Time.now.to_i}-#{application}.psql"

      run %{pg_dump -x -Fc #{prod["database"]} -f #{dump}}
      get dump, dump
      run "rm #{dump}"

      system %{dropdb #{dev["database"]}}
      system %{createdb #{dev["database"]} -O #{dev["username"]}}
      system %{pg_restore -O -U #{dev["username"]} -d #{dev["database"]} #{dump}}
      system "rm #{dump}"
    end

    desc "Syncs the database.yml file from the local machine to the remote machine"
    task :sync_yaml do
      puts "\n\n=== Syncing database yaml to the production server! ===\n\n"
      unless File.exist?("config/database.yml")
        puts "There is no config/database.yml.\n "
        exit
      end
      system "rsync -vr --exclude='.DS_Store' config/database.yml #{user}@#{remote_host}:#{shared_path}/config/"
    end

    desc "Create Production Database"
    task :create do
      puts "\n\n=== Creating the Production Database! ===\n\n"
      run "cd #{release_path}; rake db:create RAILS_ENV=production"
      system "cap deploy:set_permissions"
    end

    desc "Migrate Production Database"
    task :migrate do
      puts "\n\n=== Migrating the Production Database! ===\n\n"
      run "cd #{release_path}; rake db:migrate RAILS_ENV=production"
      system "cap deploy:set_permissions"
    end

    desc "Resets the Production Database"
    task :migrate_reset do
      puts "\n\n=== Resetting the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:migrate:reset RAILS_ENV=production"
    end

    desc "Destroys Production Database"
    task :drop do
      puts "\n\n=== Destroying the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:drop RAILS_ENV=production"
      system "cap deploy:set_permissions"
    end

    desc "Populates the Production Database"
    task :seed do
      puts "\n\n=== Populating the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:seed RAILS_ENV=production"
    end

  end

  namespace :sunspot do
    
    desc "Populates the Production Database"
    task :reindex do
      puts "\n\n=== Reindex sunspot! ===\n\n"
      run "cd #{current_path}; rake sunspot:solr:reindex RAILS_ENV=production"
    end
    
  end
  
  namespace :gems do

    desc "Installs any 'not-yet-installed' gems on the production server or a single gem when the gem= is specified."
    task :install do
      if ENV['gem']
        puts "\n\n=== Installing #{ENV['gem']}! ===\n\n"
        run "gem install #{ENV['gem']}"
      else
        puts "\n\n=== Installing required RubyGems! ===\n\n"
        run "cd #{current_path}; rake gems:install RAILS_ENV=production"
      end
    end

  end

  namespace :whenever do

    desc "Update the crontab file for the Whenever Gem."
    task :update_crontab, :roles => :app do
      puts "\n\n=== Updating the Crontab! ===\n\n"
      run "cd #{release_path} && whenever --update-crontab #{application}"
    end

  end

  namespace :delayed_job do
    desc "Starts the Delayed Job Daemon(s)."
    task :start do
      puts "\n\n=== Starting #{(ENV['n'] + ' ') if ENV['n']}Delayed Job Daemon(s)! ===\n\n"
      run "RAILS_ENV=production #{current_path}/script/delayed_job #{"-n #{ENV['n']} " if ENV['n']}start"
    end
    desc "Stops the Delayed Job Daemon(s)."
    task :stop do
      puts "\n\n=== Stopping Delayed Job Daemon(s)! ===\n\n"
      run "RAILS_ENV=production #{current_path}/script/delayed_job stop"
    end

  end

  namespace :apache do

    desc "Adds Apache2 configuration and enables it."
    task :create do
      puts "\n\n=== Adding Apache2 Virtual Host for #{domain}! ===\n\n"
      config = <<-CONFIG
<VirtualHost *:80>
ServerName #{domain}
      #{unless subdomain then "ServerAlias www.#{domain}" end}
DocumentRoot #{File.join(deploy_to, 'current', 'public')}
</VirtualHost>
      CONFIG

      system 'mkdir tmp'
      file = File.new("tmp/#{domain}", "w")
      file << config
      file.close
      system "rsync -vr tmp/#{domain} #{user}@#{application}:/etc/apache2/sites-available/#{domain}"
      File.delete("tmp/#{domain}")
      run "sudo a2ensite #{domain}"
      run "sudo /etc/init.d/apache2 restart"
    end

    desc "Restarts Apache2."
    task :restart do
      run "sudo /etc/init.d/apache2 restart"
    end

    desc "Removes Apache2 configuration and disables it."
    task :destroy do
      puts "\n\n=== Removing Apache2 Virtual Host for #{domain}! ===\n\n"
      begin run("a2dissite #{domain}"); rescue; end
      begin run("sudo rm /etc/apache2/sites-available/#{domain}"); rescue; end
      run("sudo /etc/init.d/apache2 restart")
    end

  end


  desc "Run a command on the remote server. Specify command='my_command'."
  task :run_command do
    run "cd #{current_path}; #{ENV['command']}"
  end

  desc "Set tmp/assets dir permissions."
  task :tmp_permissions do
    run "cd #{current_path}; chmod -R 0777 tmp/cache"
  end
  
  # Tasks that run after the (cap deploy:setup)

  desc "Sets up the shared path"
  task :setup_shared_path do
    puts "\n\n=== Setting up the shared path! ===\n\n"
    directory_configuration.each do |directory|
      run "mkdir -p #{shared_path}/#{directory}"
    end
    system "cap deploy:db:sync_yaml"
  end
  
  task :precompile, :role => :app do
    run "cd #{release_path}/ && rake assets:precompile"
  end

  task :secret_token, :role => :app do
    system "rsync -vr --exclude='.DS_Store' config/initializers/secret_token.rb #{user}@#{remote_host}:#{release_path}/config/initializers/"
  end
  
  task :twitter, :role => :app do
    system "rsync -vr --exclude='.DS_Store' config/initializers/000_twitter.rb #{user}@#{remote_host}:#{release_path}/config/initializers/"
  end
  
  task :credential, :role => :app do
    system "rsync -vr --exclude='.DS_Store' config/initializers/credential.rb #{user}@#{remote_host}:#{release_path}/config/initializers/"
  end
  
end

# Callbacks
before :deploy, 'deploy:delayed_job:stop'
after 'deploy:setup', 'deploy:setup_shared_path'
after 'deploy:finalize_update', 'deploy:db:sync_yaml', 'deploy:secret_token', 'deploy:twitter', 'deploy:credential', 'deploy:setup_symlinks'
after 'deploy:finalize_update', 'deploy:db:migrate', "deploy:precompile", "deploy:delayed_job:start"
after 'deploy:create_symlink', "deploy:tmp_permissions"