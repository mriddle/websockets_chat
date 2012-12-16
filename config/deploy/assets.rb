Capistrano::Configuration.instance(:must_exist).load do
  namespace :deploy do
    namespace :assets do
      desc 'compile all assets'
      task :compile do
        run %{cd #{release_path}; bundle exec rake assets:compile}
      end
    end
  end
end