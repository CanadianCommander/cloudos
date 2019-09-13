module Auth end
require 'singleton'

class Auth::AuthenticationService
  include Singleton

  DOCKER_SUBNET = "172.17.0.".freeze # xx

  # check if the ip is authorized to access the api
  def is_authorized_ip_api(ip)
    unless is_ip_local(ip)
      raise Auth::NotAuthorizedException.new("The ip [#{ip}] is not authorized to access the api")
    end
  end

  # check if ip address is local. i.e. localhost or docker subnet
  def is_ip_local(ip)
    ip.match(/#{DOCKER_SUBNET}\d+/) || ip.match(/127.0.0.\d+/)
  end

end

# thrown in the event that access to a resource is not authorized
class Auth::NotAuthorizedException < RuntimeError

end