require 'new_relic/recipes'
require "bundler/capistrano"
require 'yaml'
require './app/lib/environment_initializer'

EnvironmentInitializer.new

site_config = YAML.load_file('config/site_config.yml')["site"]

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :application, site_config['app_name']
set :repository,  site_config['app_repo']
set :scm, :git
set :user, site_config['deploy_user']

set :deploy_to, "/var/www"
set :deploy_via, :remote_cache
set :branch, "master"

set :rails_env, 'production'
server site_config['app_server'], :app, :web, :db, :primary => true

%w{ helpers unicorn chef assets}.each do |f|
  require File.expand_path("../deploy/#{f}", __FILE__)
end

after "deploy:update", "deploy:assets:compile", "newrelic:notice_deployment"

before('deploy:finalize_update', :chef)
