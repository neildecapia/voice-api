namespace :unicorn do
  desc 'Setup unicorn config'
  task :setup do
    on roles(:app) do |host|
      config = ERB.new(File.read(File.dirname(__FILE__) + '/templates/unicorn.erb')).result(binding)
      upload! StringIO.new(config), "#{shared_path}/config/unicorn.rb"
    end
  end

  desc 'Start unicorn'
  task start: 'deploy:set_rails_env'  do
    on roles(:app) do |host|
      execute "cd #{current_path} && bundle exec unicorn_rails -c #{current_path}/config/unicorn.rb -E #{fetch(:rails_env)} -D"
    end
  end

  desc 'Gracefully stop unicorn'
  task :stop do
    on roles(:app) do |host|
      execute "/bin/bash -c 'kill -s QUIT `cat #{current_path}/tmp/pids/unicorn.pid`'"
    end
  end

  desc 'Restart unicorn'
  task :restart do
    on roles(:app) do |host|
      execute "/bin/bash -c 'kill -s USR2 `cat #{current_path}/tmp/pids/unicorn.pid`'"
    end
  end
end

namespace :deploy do
  before :updated, 'unicorn:setup'

  %w{start stop restart}.each do |cmd|
    task cmd.to_sym do
      on roles(:app) do |host|
        invoke "unicorn:#{cmd}"
      end
    end
  end
end
