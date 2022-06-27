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

def iata(host, port, url, loginindex, savedirectory, filepath)
  f = File.open("outlog-#{loginindex}.txt","a+")

  proxyhost = nil
  proxyport = 0

  while $qlines.any? do
    begin
      request_obj = build_request(url, user, password, savedirectory, proxyhost, proxyport)
      s = TCPSocket.new(host, port)
      s.puts(request_obj.to_json)
      line = nil
      status_tickets = {}
      loop do
        Timeout.timeout(300) { line = s.gets }
        break if !line
        line = line.strip
        puts "received: #{line[0..1000]}"
        f << line << "\n"
        f.flush
        begin
          obj = JSON.parse(line)
          if obj["type"] == "productions" && obj["message"] && obj["message"]["productions"]
            client.update_kaogu_status("productions", obj["message"]["productions"])
            break
          end
        rescue => e
          puts "failed to parse #{line[0..1000]} to JSON, error was #{e.message}"
        end
      end
      if request_obj["tickets"].size > status_tickets.size
        puts "error condition, sleeping 4 minutes"
        sleep 240
      end
    rescue => e
      puts "failed, error was #{e.message}"
    rescue Timeout::Error
      puts "Timeout exception on formcrawl"
      f << %{{"type":"ticketstatus","message":{"error":"timeout"}}}
      f << "\n"
      return JSON.parse(" {\"type\": \"timeout\"} ")
    end
  end
  f.close
end

# iata("localhost", ARGV[0].to_i, "https://portal.iata.org", ARGV[1].to_i, "c:\\\\users\\\\justin\\\\dump", ARGV[3])
# iata("localhost", 2112, "https://portal.iata.org", 0, "c:\\\\users\\\\justin\\\\dump", 'iatatest.csv')

########################### ########################### ###########################

class Worker
  attr_reader :worker_id, :host, :port, :separator, :client, :socket, :run_key_id, :username, :tickets
  GROUP_NUMBER = 50

  def initialize(worker_id, port)
    @worker_id = worker_id
    @host = 'localhost'
    @port = port
    @separator = RUBY_PLATFORM.match(/w32/) ? "\\" : "/"
  end

  def crawl
    rk = $runkeys[worker_id]
    @run_key_id = rk['bsp_downloader_run_key_id']
    @username = rk['username']
    @token = rk['token']
    @iatanumber = rk['iatanumber']
    @bitmask = rk['bitmask']
    @client ||= Client.new(worker_id, run_key_id)
    client.update_downloader_runkey_status('crawling', nil, nil, nil)
    #f = File.open("outlog-#{run_key_id}.txt","a+")
    status = 'success'
    error_reason = ''
    begin
      request_obj = build_request(username, worker_id)
      s = TCPSocket.new(host, port)
      s.puts(request_obj.to_json)
      line = nil
      tickets_status = {}
      loop do
        break if !IO.select([s], nil, nil, 300)
        line = s.gets
        break if !line
        line = line.strip
        puts "received #{worker_id}: #{line[0..1000]}"
        #f << line << "\n"
        #f.flush
	      $heartbeat[worker_id] = Time.now
        begin
          obj = JSON.parse(line)
          if obj["type"] == "ticketstatus" && obj["message"] && obj['message']['status'] && (obj["message"]["ticketNumber"] || obj["message"]["filename"] || obj["message"]["error"])
            filename = obj['message']['filename']
            filepath = filename.nil? ? nil : "/home/juschan/bspdownloads/files/" + filename
            error = obj['message']['error']
            ticketstatus = obj['message']['status']
            pdfinfo = obj['message']['pdfdownloads']

            client.update_downloader_runkey_status(ticketstatus, error, filepath, pdfinfo ? pdfinfo.to_json : nil)
            break
          # elsif obj["type"] == "downloadfile" && obj["message"] && obj["message"]["filename"]
          #   filepath = "/srv/dyson/bsp/files/" + obj["message"]["filename"]
          #   client.import_etickets(filepath)
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

  def build_request(username, worker_id, proxyhost = nil, proxyport = 0)
    password = $bsplogins[username]
    obj = {
      "debug"=> true,
      "force"=> true,
      "requestType"=> "iata",
      "url"=> $url,
      "logToFile" => true,
      "username"=> username,
      "password"=> password,
      "tokenUrl" => "#{$dyson_api_host}/api/workers/#{worker_id}/bsp_run_keys/get_2fa_token",
      "saveDirectory"=> $savedirectory,
      "removecookies"=> true,
      "getRAInfo"=> true,
      "iatanumber" => @iatanumber,
      "bitmask" => @bitmask,
    }
    if proxyhost && proxyport > 0
      obj = obj.merge(
      "proxy"=>
        { "host"=> proxyhost,
          "port"=> proxyport }
      )
    end
    if username.match(/iataraect/i)
      obj = obj.merge("getRAPDF"=> true)
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
  $savedirectory = 'S:\\bspdownloads'
  $dyson_api_host = "chcxjuschan001:3010"
  $url = 'https://portal.iata.org'
  $profile_format = 'bspdownload%02d'
  $workers_count = 1
  $port = 4568
  $timeout = 60000
  $bsplogins = {
    "pbutcher@expediagroup.com" => "RefundBSP1!pb",
    "iatara@expedia.com" => "BSPRefund9!",
    "iataraemea@expedia.com" => "BSPRefund9!",
    "iatarade@expedia.com" => "BSPRefund9!",
    "iatarauk@expedia.com" => "BSPRefund9!",
    "iatarafr@expedia.com" => "BSPRefund9!",
    "iatarascandic@expedia.com" => "BSPRefund9!",
    "iataraamer@expedia.com" => "BSPRefund9!",
    "iataraapac@expedia.com" => "BSPRefund9!",
    "iataraect@expedia.com" => "BSPRefund10!",
    "afexc@expedia.com" => "Expedia:)20",
    "v-juschan@expediagroup.com" => "BSPRefund10!",
  }
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
  $runkeys[worker_id] = Client.download_run_key(worker_id)
  # `firefox -no-remote ..` is blocking in ruby though non-blocking in windows cmd => must use thread
  $driver_threads[worker_id] = Thread.new { `"C:\\Program Files\\Mozilla Firefox\\firefox" -no-remote -profile c:\\profiles\\#{worker_id}` }
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
    sleep 1
  end
rescue => e
  puts "crawl_sites: #{e}; #{e.backtrace[0..4]}"
end

crawl_run_keys
