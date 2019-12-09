

require 'base64'
require 'singleton'

module Auth
  class AuthenticationService
    include Singleton

    DOCKER_SUBNET = "172.17.0.".freeze # xx

    # check if the request is authorized to access the api
    def is_authorized_ip(ip)
      unless is_ip_allowed_api(ip)
        raise NotAuthorizedException.new("The ip [#{ip}] is not authorized to access the api")
      end
    end

    # check if the ip address is allowed to access the api.
    def is_ip_allowed_api(ip)
      authorized = false
      Rails.application.config.settings[:api][:ip_white_list].each do |allowed_ip|
        allowed_ip = allowed_ip.gsub(".", "\\.").gsub("*", ".*")
        authorized = authorized || ip.match(allowed_ip)
      end

      return authorized
    end

    # get the api token from the request object
    def get_request_token(request)
      if request.headers.include?("Authorization")
        token = request.headers["Authorization"].match(/\s*Bearer\s+([^\s]+)/)
        if !token.nil? && token.size > 1
          return token[1]
        end
      end

      raise AuthorizationException.new("Missing HTTP Authorization header.")
    end

    # perform api token authorization / creation
    def new_api_token(user_name, password)
      user = User.where(email: user_name)
      if user.size == 1
        if user[0].valid_password?(password)
          return new_api_token_direct(user[0].id)
        else
          raise AuthorizationException.new("Failed to authenticate")
        end
      else
        # dont let remote know if user exists or not.
        raise AuthorizationException.new("Failed to authenticate")
      end
    end

    # create a new api token for the user id without authentication checks
    def new_api_token_direct(user_id)
      return ApiSession.new_api_session(user_id)
    end

    # extract user name an password form authentication request
    # returns username, password. In that order
    def extract_name_pass(request)
      if request.headers.include?("Authorization")
        auth = request.headers["Authorization"].match(/\s*Basic\s+([^\s]+)/)
        if !auth.nil? && auth.size > 1
          auth = Base64.decode64(auth[1]).split(":")
          return auth[0], auth[1]
        else
          raise AuthorizationException.new("Could not parse authorization header")
        end
      else
        raise AuthorizationException.new("Invalid Authentication Method")
      end
    end
  end
end