
class Api::ApiController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :before_api_action!
  rescue_from StandardError, with: :handle_controller_exception

  include System
  include Auth
  include JsonService
  include ErrorInterceptor

  # called before api actions are run to authenticate request
  def before_api_action!
    remote_ip = request.remote_ip
    if request.headers.include?("HTTP_X_FORWARDED_FOR")
      remote_ip = request.headers["HTTP_X_FORWARDED_FOR"]
    end
    Auth::AuthenticationService.instance.is_authorized_ip_api(remote_ip)
  end
end
