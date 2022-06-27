class Client
  attr_reader :worker_id, :run_key_id

  def initialize(worker_id, run_key_id)
    @worker_id = worker_id
    @run_key_id = run_key_id
  end

  def self.run_key(workerid)
    loop do
      rk = do_action(:get, "/run_key", {}) rescue nil
      if rk && rk['id']
        return rk
      end
      sleep 10
    end
  end

  def self.kaogu_run_key(workerid)
    loop do
      rk = do_action(:get, "/kaogu_run_key", {}) rescue nil
      if rk && rk['id']
        return rk
      end
      sleep 10
    end
  end

  def update_runkey_status(status, videos)
    post "/update_runkey_status", run_key_id: @run_key_id, status: status, videos: videos
  end

  def update_kaogu_status(status, productions)
    post "/update_kaogu_status", status: status, productions: productions
  end

  def post(resource, params = {})
    Client.do_action :post, resource, params
  end

  def put(resource, params = {})
    Client.do_action :put, resource, params
  end

  def self.do_action(action, resource, params)
    puts "Client: API #{action.to_s.upcase} #{resource} #{params}"
    args = ["#{$dyson_api_host}/api#{resource}"]
    puts args
    if params.size > 0
      if action.intern == :delete
        args[0] += (args[0] =~ /\?/ ? '&' : '?') + params.to_param
      else
        args << params.to_json
      end
    end
    args << { accept: :json, content_type: :json }
    ret = JSON.load(RestClient.send(action, *args))
    puts "Client: API Response: #{ret}"
    ret
  end

end
