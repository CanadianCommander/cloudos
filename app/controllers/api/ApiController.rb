
class Api::ApiController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :before_api_action!

  include System
  include JsonService

  # called before api actions are run to authenticate request
  def before_api_action!
    Auth::AuthenticationService.instance.is_authorized_ip_api(request.remote_ip)
  end
end
