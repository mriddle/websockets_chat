bash 'start unicorn on boot' do
  code '/usr/sbin/update-rc.d -f unicorn defaults'
  action :nothing
end

template "/etc/init.d/unicorn" do
  source "unicorn.init.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :run, resources(:bash => 'start unicorn on boot'), :immediately
end


logrotate_conf 'rails' do
  path '/var/www/shared/log/*.log'
  frequency 'daily'
  rotate '90'
end

tasks_dir = "/var/www/current/script/tasks"
task_command = "cd /var/www/current && RAILS_ENV=#{node['rails_env']} ./script/tasks"

cron "rails hourly" do
  minute "17"
  path '/usr/local/bin:/usr/bin:/bin'
  command "#{task_command}/hourly"
end

cron "rails daily" do
  hour "15"
  minute "33"
  path '/usr/local/bin:/usr/bin:/bin'
  command "#{task_command}/daily"
end

cron "rails weekly" do
  weekday "1"
  hour "15"
  minute "48"
  path '/usr/local/bin:/usr/bin:/bin'
  command "#{task_command}/weekly"
end
