environment ENV['RAILS_ENV'] || 'development'

daemonize true

pidfile "/home/deploy/greentest/tmp/pids/puma.pid"
stdout_redirect "/home/deploy/greentest/log/stdout", "/home/deploy/greentest/log/stderr"

threads 5, 5

bind "unix:/home/deploy/greentest/tmp/sockets/puma.sock"
