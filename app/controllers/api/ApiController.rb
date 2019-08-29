class Api::ApiController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  include Api::System
  include Api::JsonService
end
