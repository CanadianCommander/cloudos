
class Auth::ApiSession < ApplicationRecord
  belongs_to :user, class_name: "User"

  def self.new_api_session(user_id, ttl=3600)

  end
end