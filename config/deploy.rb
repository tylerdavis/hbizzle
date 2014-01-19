set :application, 'hbizzle.com'
set :repo_url, 'git@github.com:tylerdavis/hbizzle.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/home/hbizzle/hbizzle.com'
set :scm, :git

set :rvm_type, :user
set :rails_env, 'production'

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

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

task :query_interactive do
  on 'hbizzle@beta.hbizzle.com' do
    info capture("[[ $- == *i* ]] && echo 'Interactive' || echo 'Not interactive'")
  end
end

task :query_login do
  on 'hbizzle@beta.hbizzle.com' do
    info capture("shopt -q login_shell && echo 'Login shell' || echo 'Not login shell'")
  end
end