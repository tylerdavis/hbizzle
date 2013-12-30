set :application, 'hbizzle'
set :repo_url, 'git@github.com:tylerdavis/hbizzle.git'

set :user, 'root'
set :deploy_to, "/home/hbizzle"
set :use_sudo, false
set :scm, :git

set :web, "192.241.239.165"
set :app, "192.241.239.165"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
