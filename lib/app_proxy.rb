require 'rack-proxy'

class AppProxy < Rack::Proxy
  def initialize(app)
    @app = app
  end

  def call(env)
    original_host = env["HTTP_HOST"]
    rewrite_env(env)
    if env["HTTP_HOST"] != original_host
      perform_request(env)
    else
      # continue as normal
      @app.call(env)
    end
  end

  def rewrite_env(env)
    request = Rack::Request.new(env)
    # proxy logic
    if request.port >= Rails.application.config.proxy[:app_port_star] && request.port <= Rails.application.config.proxy[:app_port_end]
      if request.path =~ /^#{Rails.application.config.proxy[:reserved_path]}.*/
        Rails.logger.debug "Proxy to /cloudos/ path"
        # TODO route to cloudos controller(s)
      else
        proxy = System::ProxyService.instance.get_proxy_by_external_port(request.port)

        if proxy.nil?
          Rails.logger.warn "No proxy record found for: #{request.port}"
        else
          env['HTTP_HOST'] = "#{proxy.internal_ip}:#{proxy.internal_port}"
          env['rack.url_scheme'] = proxy.proto.to_s
        end
      end
    else
      Rails.logger.debug "No Proxy, continue to api"
    end
    env
  end
end
