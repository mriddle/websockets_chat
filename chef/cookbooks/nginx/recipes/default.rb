src_filename = "nginx-#{node[:nginx][:version]}.tar.gz"

include_recipe "build-essential"

%w{libpcre3 libpcre3-dev libssl-dev libgeoip-dev geoip-database}.each do |pkg|
  package pkg
end

user node[:nginx][:user] do
  system true
  shell "/bin/false"
  home "/var/www"
end

directory node[:nginx][:log_dir] do
  mode "0755"
  owner node[:nginx][:user]
  action :create
end

directory node[:nginx][:dir] do
  owner "root"
  group "root"
  mode "0755"
end

%w{ sites-available sites-enabled conf.d }.each do |dir|
  directory "#{node[:nginx][:dir]}/#{dir}" do
    owner "root"
    group "root"
    mode "0755"
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/#{src_filename}" do
  source node[:nginx][:source][:url]
  action :create_if_missing
end

bash "compile_nginx_source" do
  user 'root'
  cwd Chef::Config[:file_cache_path]
  code <<-BASH
    tar zxf #{src_filename}
    cd nginx-#{node[:nginx][:version]}
    ./configure #{node[:nginx][:source][:configure_flags].join(" ")}
    make && make install
  BASH
  not_if "test -d #{Chef::Config[:file_cache_path]}/nginx-#{node[:nginx][:version]}"
end


template "/etc/init.d/nginx" do
  source "nginx.init.erb"
  owner "root"
  group "root"
  mode "0755"
  variables(
    :pid => node[:nginx][:pid],
    :daemon => node[:nginx][:binary]
  )
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action :enable
end

template "nginx.conf" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[nginx]"
end

remote_file "#{Chef::Config[:file_cache_path]}/GeoLiteCity.dat.gz" do
  source 'http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz'
  mode "0644"
  action :create_if_missing
  not_if "test -d #{node[:nginx][:geoip][:city_path]}"
end

bash 'untar city data file' do
  user 'root'
  cwd Chef::Config[:file_cache_path]
  code <<-BASH
    gunzip GeoLiteCity.dat.gz
    cp GeoLiteCity.dat #{node[:nginx][:geoip][:city_path]}
  BASH
  not_if "test -d #{node[:nginx][:geoip][:city_path]}"
end

template "#{node[:nginx][:dir]}/conf.d/http_geoip.conf" do
  source "modules/geoip.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :country_dat => node[:nginx][:geoip][:country_path],
    :city_dat => node[:nginx][:geoip][:city_path]
  )
  notifies :reload, "service[nginx]"
end

template "#{node[:nginx][:dir]}/sites-available/default" do
  source "default-site.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, "service[nginx]"
end

cookbook_file "#{node[:nginx][:dir]}/mime.types" do
  source "mime.types"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "nginx")
end

link "/etc/nginx/sites-enabled/default" do
  to "/etc/nginx/sites-available/default"
  notifies :reload, "service[nginx]"
end


service "nginx" do
  action :start
end