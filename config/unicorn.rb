# set path to application
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"
working_directory app_dir


# Set unicorn options
worker_processes 2
preload_app true
timeout 30

# Set up socket location
#listen "#{shared_dir}/sockets/unicorn.sock", :backlog => 64

# Set master PID location
#pid "#{shared_dir}/pids/unicorn.pid"

before_fork do |server, worker|
end

after_fork do |server, worker|
end
