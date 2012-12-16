require 'yaml'

class EnvironmentInitializer
  def initialize
    file_path = 'config/secretes.yml'
    unless File.exists? file_path
      raise "\nERROR: #{Dir.getwd + "/" + file_path} not found!\nWhere are your secretes?\nSee #{file_path}.example"
    end
    config = YAML.load_file(file_path)
    config.each {|key, value| ENV[key.upcase] = value}
  end
end