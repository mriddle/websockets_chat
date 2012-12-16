require 'sinatra/base'
require 'sinatra/config_file'
require 'sprockets'

require_relative 'lib/asset_helper'

class Base < Sinatra::Base
  register Sinatra::ConfigFile

  set :root, File.expand_path('../../', __FILE__)

  config_file File.join(root, 'config/site_config.yml')

  set :sprockets, Sprockets::Environment.new(root)
  set :precompile, [ /\w+\.(?!js|css).+/, /(application|vendor).(css|js)$/ ]
  set :assets_prefix, 'assets'
  set :assets_path, File.join(root, 'public', assets_prefix)
  set :views, Proc.new { File.join(root, "app/views") }

  configure do
    ["assets", "vendor"].each do |path|
      ["stylesheets", "javascripts", "images"].each do |asset_folder|
        sprockets.append_path(File.join(root, path, asset_folder))
      end
    end

    sprockets.context_class.instance_eval do
      include AssetHelpers
    end
  end

  helpers do
    include AssetHelpers
  end

  before do
    @site_config = settings.site
  end

  get '/404' do
    haml :'404'
  end

  get '/500' do
    haml :'500'
  end

  not_found do
    haml :'404'
  end

  error do
    haml :'500'
  end

end
