environment ENV['RAILS_ENV'] || 'development'

daemonize true

pidfile "//var/www/greentest/tmp/pids/puma.pid"
stdout_redirect "//var/www/greentest/log/stdout", "//var/www/greentest/log/stderr"

threads 0, 16

bind "unix:///tmp/deploy.sock"
