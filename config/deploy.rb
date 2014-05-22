# config valid only for Capistrano 3.1
lock '3.2.1'



set :application, 'test2'
#set :repo_url, 'git@github.com:stackexpress-shivam/test2.git'
set :repo_url, 'https://github.com/stackexpress-shivam/test2.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
set :scm, :git

set :pty, true
set :user, 'deploy'
set :use_sudo, false
set :deploy_to, "/home/deploy/apps/testapp1/"
set :app_path, "/home/deploy/apps/testapp1/current"

set :current_path, "/home/deploy/apps/testapp1/current"
set :shared_path, "/home/deploy/apps/testapp1/shared"

set :rails_env, "production"
#set :deploy_via, :copy
#set :deploy_via, :remote_cache

set :stages, ["staging", "production"]
set :default_stage, "production"

role :web, "192.168.33.10"                          # Your HTTP server, Apache/etc
role :app, "192.168.33.10"                          # This may be the same as your `Web` server
#role :db,  "192.168.33.11", :primary => true


# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5


#namespace :deploy do
#  task :start do ; end
#  task :stop do ; end
#  task :restart, :roles => :app, :except => { :no_release => true } do
#    run "touch #{File.join(current_path,'tmp','restart.txt')}"
#  end
#end



namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end




after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: { no_release: true } do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    # symlink the unicorn init file in /etc/init.d/
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    # create a shared directory to keep files that are not in git and that are used for the application
    run "mkdir -p #{shared_path}/config"
    # if you're using mongoid, create a mongoid.template.yml file and fill it with your production configuration
    # and add your mongoid.yml file to .gitignore
    put File.read("config/mongoid.template.yml"), "#{shared_path}/config/mongoid.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end









#require 'capistrano-unicorn'
#after 'deploy:restart', 'unicorn:reload'    # app IS NOT preloaded
#after 'deploy:restart', 'unicorn:restart'   # app preloaded