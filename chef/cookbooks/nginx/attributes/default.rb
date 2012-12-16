default[:nginx][:version]                          = "1.2.0"
default[:nginx][:dir]        = "/etc/nginx"
default[:nginx][:log_dir]    = "/var/log/nginx"
default[:nginx][:user]       = "www-data"
default[:nginx][:binary]     = "/usr/sbin/nginx"
default[:nginx][:pid]        = "/var/run/nginx.pid"

default[:nginx][:source][:url]                     = "http://nginx.org/download/nginx-#{node[:nginx][:version]}.tar.gz"
default[:nginx][:source][:conf_path]               = "#{node[:nginx][:dir]}/nginx.conf"
default[:nginx][:source][:configure_flags]         = [
                                                       "--prefix=/etc/nginx",
                                                       "--sbin-path=#{node[:nginx][:binary]}",
                                                       "--conf-path=#{node[:nginx][:source][:conf_path]}",
                                                       "--pid-path=#{node[:nginx][:pid]}",
                                                       "--with-http_gzip_static_module",
                                                       "--with-http_ssl_module",
                                                       "--with-http_geoip_module"
                                                     ]

default[:nginx][:gzip]              = "on"
default[:nginx][:gzip_http_version] = "1.0"
default[:nginx][:gzip_comp_level]   = "7"
default[:nginx][:gzip_proxied]      = "any"
default[:nginx][:gzip_types]        = [
  "text/plain",
  "text/css",
  "application/x-javascript",
  "text/xml",
  "application/xml",
  "application/xml+rss",
  "text/javascript",
  "application/javascript",
  "application/json"
]

default[:nginx][:keepalive]          = "off"
default[:nginx][:keepalive_timeout]  = 30
default[:nginx][:worker_processes]   = cpu[:total] + 1
default[:nginx][:worker_connections] = 1024
default[:nginx][:server_names_hash_bucket_size] = 64

default[:nginx][:geoip][:country_path] = "/usr/share/GeoIP/GeoIP.dat"
default[:nginx][:geoip][:city_path] = "/usr/share/GeoIP/GeoLiteCity.dat"