root = File.absolute_path(File.dirname(__FILE__))

cookbook_path root + '/cookbooks'
role_path root + "/roles"
log_level :debug
log_location STDOUT
