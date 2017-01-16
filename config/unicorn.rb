APP_INSTANCE_NUMBER = ENV['APP_INSTANCE_NUMBER'] || 1

# set path to application
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"
working_directory app_dir


# Set unicorn options
worker_processes 2
preload_app true
timeout 30

# Set up socket location
listen "#{shared_dir}/sockets/unicorn-#{APP_INSTANCE_NUMBER}.sock", :backlog => 64

# Logging
stderr_path "#{shared_dir}/log/unicorn-#{APP_INSTANCE_NUMBER}.stderr.log"
stdout_path "#{shared_dir}/log/unicorn-#{APP_INSTANCE_NUMBER}.stdout.log"

# Set master PID location
pid "#{shared_dir}/pids/unicorn-#{APP_INSTANCE_NUMBER}.pid"
