env = {
  :app_home => ENV['UNICORN_HOME'] || File.expand_path('../../', __FILE__)
}
worker_processes 2
working_directory env[:app_home]
listen 3000

timeout 90

pid File.expand_path('../tmp/pids/unicorn.pid', env[:app_home])

preload_app true

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{env[:app_home]}/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  old_pid = env[:app_home] + '/tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end
