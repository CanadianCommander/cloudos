class Api::Auth::ApiAuthController < Api::ApiController
  skip_before_action :before_api_action!
  # WARN unprotected endpoints

  def initialize
    super

    @authentication_service = AuthenticationService.instance
  end

  #GET auth/token
  def get_api_token
    user_name, password = @authentication_service.extract_name_pass(request)
    @authentication_service.get_api_token(user_name, password)

  end

end