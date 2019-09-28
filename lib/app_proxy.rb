require 'rack-proxy'
require 'socket'
require 'faye/websocket'
require 'cgi'
require 'base64'
require 'active_support'
require_relative '../app/services/auth/authentication_service'

class AppProxy < Rack::Proxy
  def initialize(app)
    @app = app
    @hostname = (`hostname`).strip
  end

  def call(env)
    original_host = env["HTTP_HOST"]

    remove_x_forward_headers(env)
    case get_proxy_mode(env)
    when :app_proxy
      begin
        check_request_authentication(env)
      rescue Auth::NotAuthorizedException => e
        return redirect_to_login(env)
      end

      proxy = get_proxy(env)
      if proxy.nil?
        ["404", {}, []]
      else
        if Faye::WebSocket.websocket?(env)
          return perform_ws_proxy(env, proxy)
        else
          rewrite_env_app_proxy(env, proxy)
          perform_request(env)
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

  def remove_x_forward_headers(env)
    # headers set by apache what will confuse Net::HTTP, in to sending the request back to our self.
    env.delete('HTTP_X_FORWARDED_HOST')
    env.delete('HTTP_X_FORWARDED_SERVER')
  end

  # perform websocket proxy
  def perform_ws_proxy(env, proxy)
    client_request = Rack::Request.new(env)
    # client of the web socket proxy
    ws_client = Faye::WebSocket.new(env)
    # server of the web socket proxy
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

  # check if the session is authenticated. i.e. user is logged in.
  # if not raise NotAuthorizedException
  def check_request_authentication(env)
    unless env['warden'].authenticated?
      raise Auth::NotAuthorizedException.new("Request is not authorized")
    end
  end

  def redirect_to_login(env)
    [ 302, {'Location' =>"https://#{@hostname}"}, [] ]
  end
end
