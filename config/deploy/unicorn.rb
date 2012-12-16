Capistrano::Configuration.instance(:must_exist).load do
  set :unicorn_binary, "/usr/bin/unicorn"
  set :unicorn_config, "#{current_path}/config/unicorn.rb"
  set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

  namespace :deploy do
    task :start, :roles => :app, :except => { :no_release => true } do
      run "cd #{current_path} && BUNDLE_GEMFILE=#{current_path}/Gemfile bundle exec unicorn_rails -c #{unicorn_config} -E #{rails_env} -D"
    end

    task :stop, :roles => :app, :except => { :no_release => true } do
      run "#{try_sudo} kill `cat #{unicorn_pid}`"
    end

    task :graceful_stop, :roles => :app, :except => { :no_release => true } do
      run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
    end

    task :reload, :roles => :app, :except => { :no_release => true } do
      run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
    end

    task :restart, :roles => :app, :except => { :no_release => true } do
      if remote_process_exists?(unicorn_pid)
        run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
      else
        start
      end
    end
  end
end