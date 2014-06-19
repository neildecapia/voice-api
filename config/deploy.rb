# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'voice_api'

set :scm, :git
set :repo_url, 'git@192.168.66.58:root/api-project.git'
set :branch, 'master'

# Default deploy_to directory is /var/www/my_app
#set :deploy_to, '/var/www/my_app'
# Default value for default_env is {}
#set :default_env, { path: "/opt/ruby/bin:$PATH" }
# Default value for keep_releases is 5
#set :keep_releases, 5

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_files, %w{config/database.yml config/secrets.yml config/asterisk.yml config/carrierwave.yml config/assets.yml config/unicorn.rb}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

load 'config/deploy/extensions/rbenv.rb'
load 'config/deploy/extensions/unicorn.rb'
load 'config/deploy/extensions/nginx.rb'

namespace :deploy do
  after :publishing, :restart
end
