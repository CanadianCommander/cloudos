class Api::Auth::ApiAuthController < Api::ApiController
  skip_before_action :authenticate_remote_request!
  # WARN unprotected endpoints

  def initialize
    super
    @authentication_service = AuthenticationService.instance
    @session_service = SessionService.instance
  end

  #POST auth/token
  def get_api_token
    if session.has_key?("warden.user.user.key")
      user = User.find(session["warden.user.user.key"][0][0])
      render json: success_response(@authentication_service.new_api_token_direct(user.id))
    else
      user_name, password = @authentication_service.extract_name_pass(request)
      render json: success_response(@authentication_service.new_api_token(user_name, password))
    end
  end

  #GET auth/valid
  def is_token_valid?
    token = @authentication_service.get_request_token(request)
    render json: success_response({ valid: @session_service.is_valid?(token)})
  end

end