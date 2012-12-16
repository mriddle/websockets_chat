include_recipe 'nginx'

%w{ /var/www /var/www/releases /var/www/shared /var/www/shared/system /var/www/shared/log /var/www/shared/pids /var/www/shared/sockets }.each do |dir|
  directory dir do
    mode 0775
    owner node[:nginx][:user]
    group 'admin'
    action :create
  end
end

gem_package "bundler"