require 'rack-proxy'
require 'socket'
require 'faye/websocket'

class AppProxy < Rack::Proxy
  def initialize(app)
    @app = app
  end

  def call(env)
    original_host = env["HTTP_HOST"]

    case get_proxy_mode(env)
    when :app_proxy
      proxy = get_proxy(env)
      if proxy.nil?
        ["404", {}, []]
      else
        if Faye::WebSocket.websocket?(env)
          return perform_ws_proxy(env, proxy)
        else
          rewrite_env_app_proxy(env, proxy)
          return perform_request(env)
        end
      end
    when :cloudos_path_proxy
      Rails.logger.error "NOT IMPLEMENTED"
      return nil
      else
        return @app.call(env)
    end
  end

  # return proxy mode based on env data
  def get_proxy_mode(env)
    request = Rack::Request.new(env)
    # proxy logic
    if request.port >= Rails.application.config.proxy[:app_port_star] && request.port <= Rails.application.config.proxy[:app_port_end]
      if request.path =~ /^#{Rails.application.config.proxy[:reserved_path]}.*/
        Rails.logger.debug "Proxy to /cloudos/ path"
        # TODO route to cloudos controller(s)
        return :cloudos_path_proxy
      else
        return :app_proxy
      end
    else
      Rails.logger.debug "No Proxy, continue to api"
      return :no_proxy
    end
  end

  # get proxy model from env
  def get_proxy(env)
    request = Rack::Request.new(env)
    proxy = System::ProxyService.instance.get_proxy_by_external_port(request.port)
    if proxy.nil?
      Rails.logger.warn "No proxy record found for: #{request.port}"
      nil
    else
      proxy
    end
  end

  # rewrite env for app proxy
  def rewrite_env_app_proxy(env, proxy)
    env['HTTP_HOST'] = "#{proxy.internal_ip}:#{proxy.internal_port}"
    env['rack.url_scheme'] = proxy.proto.to_s
    env
  end

  # perform websocket proxy
  def perform_ws_proxy(env, proxy)
    client_request = Rack::Request.new(env)
    ws_client = Faye::WebSocket.new(env)
    ws_server = Faye::WebSocket::Client.new("#{proxy_proto_to_ws_proto(proxy)}://#{proxy.internal_ip}:#{proxy.internal_port}#{client_request.fullpath}")

    ws_server.on :message do |event|
      ws_client.send(event.data)
    end

    ws_client.on :message do |event|
      ws_server.send(event.data)
    end

    ws_client.on :close do |event|
      ws_client = nil
      ws_server.close
    end

    ws_client.rack_response
  end

  private

  def proxy_proto_to_ws_proto(proxy)
    case proxy.proto
    when 'http'
      'ws'
    when 'https'
      'wss'
    else
      'wss'
    end
  end

end
