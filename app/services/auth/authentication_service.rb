

require 'base64'
require 'singleton'

module Auth
  class AuthenticationService
    include Singleton

    DOCKER_SUBNET = "172.17.0.".freeze # xx

    # check if the ip is authorized to access the api
    def is_authorized_ip_api(ip)
      unless ENV.fetch("RAILS_ENV") == 'development'
        unless is_ip_local(ip)
          raise NotAuthorizedException.new("The ip [#{ip}] is not authorized to access the api")
        end
      end
    end

    # check if ip address is local. i.e. localhost or docker subnet
    def is_ip_local(ip)
      ip.match(/#{DOCKER_SUBNET}\d+/) || ip.match(/127.0.0.\d+/)
    end

    # perform api token authorization / creation
    def get_api_token(user_name, password)
      user = User.where(email: user_name)
      if user.size == 1
        if user[0].valid_password?(password)

        else
          raise AuthorizationException.new("Failed to authenticate")
        end
      else
        # dont let remote know if user exists or not.
        raise AuthorizationException.new("Failed to authenticate")
      end
    end

    def new_api_token(user_id)

    end

    # extract user name an password form authentication request
    # returns username, password. In that order
    def extract_name_pass(request)
      if request.headers.include?("Authorization")
        Rails.logger.info(request.headers["Authorization"])
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

  # thrown in the event that access to a resource is not authorized
  class NotAuthorizedException < RuntimeError

  end

  # thrown in the event that authorization has failed
  class AuthorizationException < RuntimeError

  end
end