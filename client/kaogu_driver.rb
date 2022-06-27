require 'socket'
require 'json'
require 'timeout'
require 'csv'
require 'pathname'
# require 'optparse'
require 'sinatra/base'
require 'rest-client'
require_relative '.\client'
require 'byebug'

class Worker
  attr_reader :worker_id, :host, :port, :separator, :client, :socket, :run_key_id
  GROUP_NUMBER = 50

  def initialize(worker_id, port)
    @worker_id = worker_id
    @host = 'localhost'
    @port = port
    @separator = RUBY_PLATFORM.match(/w32/) ? "\\" : "/"
  end

  def crawl
    rk = $runkeys[worker_id]
    @run_key_id = rk['id']
    @client ||= Client.new(worker_id, run_key_id)
    status = 'success'
    error_reason = ''
    begin
      request_obj = build_request(worker_id)
      s = TCPSocket.new(host, port)
      s.puts(request_obj.to_json)
      line = nil
      loop do
        break if !IO.select([s], nil, nil, 300)
        line = s.gets
        break if !line
        line = line.strip
        puts "received #{worker_id}: #{line[0..1000]}"
        f << line << "\n"
        f.flush
	      $heartbeat[worker_id] = Time.now
        begin
          obj = JSON.parse(line.force_encoding("ISO-8859-1").encode("UTF-8"))
          if obj["type"] == "productions" && obj["message"] && obj['message']['productions']
            productions = obj['message']['productions']
            client.update_kaogu_status("productions", productions)
          end
        rescue => e
          puts "failed to parse #{line[0..1000]} to JSON, error was #{e.message}"
          status = 'failed'
          error_reason = "failed to parse #{line[0..1000]} to JSON, error was #{e.message}"
        end
      end
    rescue => e
      puts "failed, error was #{e.message}"
      status = 'failed'
      error_reason = "#{e.message}\nstack:\n#{e.backtrace}"
    rescue Timeout::Error
      puts "Timeout exception on formcrawl"
      status = 'failed'
      error_reason = 'timeout'
      #f << %{{"type":"ticketstatus","message":{"error":"timeout"}}}
      #f << "\n"
      return JSON.parse(" {\"type\": \"timeout\"} ")
    end
    #client.update_runkey_status(status, error_reason)
    dispose
  end

  def build_request(worker_id, proxyhost = nil, proxyport = 0)
    obj = {
      "debug"=> true,
      "force"=> true,
      "requestType"=> "kaogujia",
      "url"=> $url,
      "videos"=>[],
    }
    if proxyhost && proxyport > 0
      obj = obj.merge(
      "proxy"=>
        { "host"=> proxyhost,
          "port"=> proxyport }
      )
    end
    obj
  end

  def dispose
    socket.close rescue 0
  end
end

######################## ######################## ########################

def kill_FF(ff_pid, worker_id)
  puts "close FF (pid #{ff_pid})", worker_id
  Process.kill("KILL", ff_pid.to_i) rescue 0
  sleep 2 # give FF some time to clean up
  $driver_threads[worker_id].kill
  sleep 1
  $heartbeat[worker_id] = nil
end

# Firefox register
def on_chromeutils_register(worker_id, port, pid, err)
  puts "chromeutils registers: port #{port}, pid #{pid} worker_id #{worker_id}"
  $heartbeat[worker_id] = Time.now
  if err == 'null'
    puts "starting crawl, set status to crawling"
    Worker.new(worker_id, port).crawl
    puts "crawled"
  else
    puts "set run key status and error to null", worker_id
    # client.update_status(nil, nil)
  end
  sleep 5
  kill_FF(pid, worker_id)
rescue => e
  puts "error on_chromeutils_register: #{e}, #{worker_id} #{e.backtrace}"
end

class CallbackWebservice < Sinatra::Base
  set :server, 'webrick'
  get '/register' do
    Thread.new {on_chromeutils_register(params['profile'], params['port'], params['pid'], params['err'])}
    "OK"
  end
end

def run_webserver
  puts "start callback webserver on port #{$port}"
  Thread.new { CallbackWebservice.run!(port: $port) }
  sleep 2
end

# all global vars are listed here
def setup
  $stdout.sync = true
  Kernel.trap( "INT" ) { exit 0 }
  $runkeys = {}
  $heartbeat = {}
  $driver_threads = {}
  $bad_worker = {}
  $hanging_worker = {}
#  $savedirectory = 'C:\\Users\\ChromeUtils\\dump'
  $dyson_api_host = "http://218.88.84.252:3014"
  $url = 'https://www.kaogujia.com/help'
  $profile_format = 'jianyi%02d'
  $workers_count = 1
  $port = 4568
  $timeout = 60000
end

setup
run_webserver

######################## ######################## ########################

def check_heartbeat(worker_id)
  if !$heartbeat[worker_id] || Time.now - $heartbeat[worker_id] > 60
    puts "no heartbeat over 60 sec (last at #{$heartbeat[worker_id]})", worker_id
    $bad_worker[worker_id] = 1
  end
end

def wait_till_addon_registers(worker_id)
  n = 0
  loop do
    return if $heartbeat[worker_id]
    n += 1
    raise 'not registered over 180 sec' if n >= 180
    sleep 1
  end
end

def start_worker(worker_id)
  $runkeys[worker_id] = Client.kaogu_run_key(worker_id)
  # `firefox -no-remote ..` is blocking in ruby though non-blocking in windows cmd => must use thread
  # c:\Program Files\Mozilla Firefox 52\firefox.exe" -no-remote -profiles c:\chromeutils\ffprofiles\jianyi01 about:debugging
  $driver_threads[worker_id] = Thread.new { `"C:\\Program Files\\Mozilla Firefox 52\\firefox.exe" -no-remote -profile c:\\chromeutils\\ffprofiles\\#{worker_id}` }
  puts "open FF", worker_id
  wait_till_addon_registers(worker_id)
rescue => e
  $hanging_worker[worker_id] = 1
  puts e, worker_id
  puts 'mark as hanging', worker_id
end

def crawl_run_keys
  worker_idx = 0
  loop do
    worker_idx += 1
    worker_idx = 1 if worker_idx > $workers_count
    worker_id = $profile_format % worker_idx
    if !$heartbeat[worker_id]
      start_worker(worker_id) if !$hanging_worker[worker_id]
    elsif !$bad_worker[worker_id]
      check_heartbeat(worker_id)
    end
    sleep 10
  end
rescue => e
  puts "crawl_sites: #{e}; #{e.backtrace[0..4]}"
end

crawl_run_keys
