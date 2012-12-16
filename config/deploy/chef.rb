Capistrano::Configuration.instance(:must_exist).load do
  namespace :chef do
    task :default do
      if dirs_changed? 'chef'
        run %{cd #{release_path}/chef; sudo chef-solo -c solo.rb -j node.json -l debug}
      else
         logger.info "Skipping cheffing because there were no changes in the chef directory"
      end
    end
  end
end