SSHKit.config.command_map[:rake] = "bundle exec rake"
lock '3.2.1'

set :application, 'prelaunchr'
set :scm, :git
set :repo_url, 'git@github.com:mithucste30/harry-s.git'

server '104.131.201.173',
  :user => 'ubuntu',
  :roles => %w{web app db}

set :rvm_roles, [:app, :web]
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-1.9.3-p286'
set :rvm_path, '/home/ubuntu/.rvm'

set :format, :pretty
set :log_level, :debug
set :pty, true
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets}

set :unicorn_config_path, "config/unicorn.rb"

set :deploy_via, :remote_cache

set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  task :clean_expired_assets do
    on roles(:app), in: :sequence, wait: 1 do
      within release_path do
        as :deploy do
          with rails_env: :production do
            execute :rake, 'assets:clean_expired', "RAILS_ENV=production"
          end
        end
      end
    end
  end

  #  before 'assets:precompile', 'cleanup_assets'
  #after 'assets:precompile', :clean_expired_assets

  after :publishing, :restart

  after :finishing, 'deploy:cleanup'

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'tmp:cache:clear'
      end
    end
  end
end