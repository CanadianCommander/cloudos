module ErrorInterceptor

  include JsonService

  def handle_controller_exception(exception)
    case exception
    when Auth::NotAuthorizedException
      unauthorized_401(exception)
    when Auth::AuthorizationException
      bad_request_400(exception)
    else
      internal_server_error_500(exception)
    end

    Rails.logger.error(exception)
  end

  def internal_server_error_500(ex)
    render json: error_response(ex.to_s), status: 500
  end

  def unauthorized_401(ex)
    render json: error_response(ex.to_s), status: 401
  end

  def bad_request_400(ex)
    render json: error_response(ex.to_s), status: 400
  end
end