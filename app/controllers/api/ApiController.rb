class Api::ApiController < ApplicationController
  skip_before_action :authenticate_user!

  include Api::System
  include Api::JsonService
end
