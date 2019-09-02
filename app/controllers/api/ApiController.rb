class Api::ApiController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  include System
  include JsonService
end
