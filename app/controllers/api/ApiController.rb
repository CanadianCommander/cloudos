
class Api::ApiController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  before_action :authenticate_remote_ip!
  before_action :authenticate_remote_request!

  rescue_from StandardError, with: :handle_controller_exception

  include System
  include Auth
  include JsonService
  include ErrorInterceptor

  # called before api actions are run to check that the request is from an allowed ip.
  def authenticate_remote_ip!
    remote_ip = request.remote_ip
    if request.headers.include?("HTTP_X_FORWARDED_FOR")
      remote_ip = request.headers["HTTP_X_FORWARDED_FOR"]
    end
    Auth::AuthenticationService.instance.is_authorized_ip(remote_ip)
  end

  # called before api actions to authenticate the request.
  # A valid request must have a valid session cookie or a valid api token.
  def authenticate_remote_request!
    begin
      token = Auth::AuthenticationService.instance.get_request_token(request)
      if Auth::SessionService.instance.is_valid?(token)
        @current_user = Auth::SessionService.instance.get_database_session(token).user
      else
        raise NotAuthorizedException.new("Not Authorized to use this resource")
      end
    rescue NoSuchSessionException, AuthorizationException  => e
      # no api token, lets try session cookie
      if session.has_key?("warden.user.user.key")
        @current_user = User.find(session["warden.user.user.key"][0][0])
      else
        raise NotAuthorizedException.new("Not Authorized to use this resource")
      end
    end
  end
end
