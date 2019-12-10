class Auth::SessionCacheSyncJob < ApplicationJob

  def perform
    session_service = Auth::SessionService.instance
    sessions = session_service.get_all_database_sessions

    # write updated map to database
    sessions.each do |session|
      if session_service.session_map.has_key?(session.uuid)
        session.expire_date = session_service.session_map[session.uuid][:expire]
        session.save!
      end
    end

    self.class.set(wait: Rails.application.config.settings[:jobs][:cache_sync_interval]).perform_later
  end
end