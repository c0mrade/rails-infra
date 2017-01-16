# set path to application
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"
working_directory app_dir


# Set unicorn options
worker_processes 2
preload_app true
timeout 30

# Set up socket location
listen "#{shared_dir}/sockets/unicorn.sock", :backlog => 64

# Set master PID location
pid "#{shared_dir}/pids/unicorn.pid"

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end

  # This log hack provides separate log files for each unicorn worker.
  # Since Unicorn forks worker processes after loggers are already initialized, by this point other
  # things (like ActiveRecord::Base.logger) are already pointing directly at the current
  # Rails.logger instance so we can't just point `Rails.logger` elsewhere.
  logdev = Rails.logger.instance_variable_get(:@logdev)

  ext = File.extname(logdev.dev.path)
  path = logdev.dev.path.gsub /#{Regexp.escape(ext)}$/, ".#{worker.nr}#{ext}"

  # open the file in the same way rails does:
  #   https://github.com/rails/rails/blob/4606e75/railties/lib/rails/application/bootstrap.rb#L38-L40
  file = File.open(path, 'a')
  file.binmode
  file.sync = Rails.application.config.autoflush_log

  logdev.dev.flush
  logdev.dev.close
  logdev.instance_variable_set(:@dev, file)
end
