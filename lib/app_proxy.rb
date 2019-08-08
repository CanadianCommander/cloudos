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
    if (request.port >= Rails.application.config.proxy[:app_port_star] && request.port <= Rails.application.config.proxy[:app_port_end])
      if request.path =~ /^#{Rails.application.config.proxy[:reserved_path]}.*/
        Rails.logger.debug "Proxy to /cloudos/ path"
        # TODO route to cloudos controller(s)
      else
        Rails.logger.debug "Proxy to application on port #{request.port}"
        # TODO proxy to real application
        env['PATH_INFO'] = "/"
        env['HTTP_HOST'] = "localhost:80"
      end
    else
      Rails.logger.debug "No Proxy, continue to api"
    end
    env
  end
end
