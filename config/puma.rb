environment ENV['RAILS_ENV'] || 'development'

threads 5, 5

if Rails.env == 'production'
  daemonize true

  pidfile "/home/deploy/greentest/tmp/pids/puma.pid"
  stdout_redirect "/home/deploy/greentest/log/stdout", "/home/deploy/greentest/log/stderr"

  bind "unix:/home/deploy/greentest/tmp/sockets/puma.sock"
end
