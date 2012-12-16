package "logrotate" do
  action :upgrade
end

bash 'restart rsyslog after logrotate' do
  user "root"
  code "sed -i 's/reload rsyslog/restart rsyslog/' /etc/logrotate.d/rsyslog"
end
