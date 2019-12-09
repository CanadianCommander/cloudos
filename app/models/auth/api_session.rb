require 'securerandom'

class Auth::ApiSession < ApplicationRecord
  belongs_to :user, class_name: "User"

  def self.new_api_session(user_id, ttl=6.hours)
    return Auth::ApiSession.create!(user_id: user_id, ttl_sec: ttl, expire_date: DateTime.current + ttl.seconds, uuid: SecureRandom.uuid)
  end
end