rails_env = ENV['RAILS_ENV'] if ENV['RAILS_ENV']
rails_env ||= 'user_test'

path = "/var/www/scorecard"
num_workers = 1

case rails_env
  when 'user_test'
    num_workers = 2
    stderr_path "#{path}/log/unicorn_err.log"
    stdout_path "#{path}/log/unicorn_out.log"
  when 'development', 'test'
    num_workers = 1
    path = "./"
end

working_directory path

# initially 4 workers and 1 master
worker_processes num_workers

# Load rails into the master before forking workers
# for super-fast worker spawn times
preload_app true

# Restart any workers that haven't responded in 5 minutes
timeout 600

# master port
listen "0.0.0.0:31000"

#
before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = Rails.root + '/tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end


after_fork do |server, worker|
  ##
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection
  ActiveRecord::Base.establish_connection

  # Redis and Memcached would go here but their connections are established
  # on demand, so the master never opens a socket

  ##
end

