require_relative 'base'

class App < Base

  get '/' do
    haml :index
  end

end
