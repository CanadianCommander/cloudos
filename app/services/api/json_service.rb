module Api::JsonService
  # json response status codes
  module STATUS
    OK      = 'ok'.freeze
    ERROR   = 'error'.freeze
  end

  # template for all json api responses
  def json_response (status, data, message)
    {
      status: status,
      data: data,
      message: message
    }
  end

  def success_response (data)
    json_response(STATUS::OK, data, "")
  end

  def error_response (msg)
    json_response(STATUS::ERROR, {}, msg)
  end
end
