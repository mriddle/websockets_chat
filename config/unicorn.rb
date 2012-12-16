app_dir = '/var/www'
worker_processes 5
working_directory "#{app_dir}/current"

# This loads the application in the master process before forking
# worker processes
# Read more about it here:
# http://unicorn.bogomips.org/Unicorn/Configurator.html
preload_app true

timeout 30

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on
listen "#{app_dir}/shared/sockets/unicorn.sock", :backlog => 64

pid "#{app_dir}/shared/pids/unicorn.pid"

# Set the path of the log files inside the log folder of the testapp
stderr_path "#{app_dir}/shared/log/unicorn.stderr.log"
stdout_path "#{app_dir}/shared/log/unicorn.stdout.log"

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
# This option works in together with preload_app true setting
# It prevents the master process from holding
# the database connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
# Here we are establishing the connection after forking worker
# processes
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

before_exec do |server|
  ENV.each do |key,value|
    server.logger.info "#{key}=#{value}"
  end
end