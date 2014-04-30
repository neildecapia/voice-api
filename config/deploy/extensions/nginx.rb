namespace :nginx do
  desc 'Setup nginx config'
  task :setup do
    on roles(:web) do |host|
      config = ERB.new(File.read(File.dirname(__FILE__) + '/templates/nginx.erb')).result(binding)
      upload! StringIO.new(config), "#{shared_path}/config/nginx.conf"
    end
  end

  desc 'Start nginx'
  task :start do
    on roles(:web) do |host|
      sudo "ln -nfs #{shared_path}/config/nginx.conf /etc/nginx/conf.d/#{fetch(:application)}.conf"
      sudo "/etc/init.d/nginx reload"
    end
  end

  task :stop do
    on roles(:web) do |host|
      sudo "rm /etc/nginx/conf.d/#{application}.conf"
      sudo "/etc/init.d/nginx reload"
    end
  end

  task :restart do
    on roles(:web) do |host|
      sudo "/etc/init.d/nginx reload"
    end
  end
end

after 'nginx:setup', 'nginx:start'

namespace :deploy do
  before :updated, 'nginx:setup'
end
