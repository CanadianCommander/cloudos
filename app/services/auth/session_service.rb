require 'singleton'

module Auth
  class SessionService
    include Singleton

    attr_accessor :session_map

    def initialize
      @session_map = Concurrent::Hash.new
    end

    # indicate that a session has just been used. Updating the expiry date accordingly
    def poke_session(uuid)
      if @session_map.has_key?(uuid)
        @session_map[uuid][:expire] = @session_map[uuid][:ttl].seconds.from_now
      else
        session = get_database_session(uuid)
        @session_map[uuid] = {
          ttl: session.ttl_sec,
          expire: DateTime.current + @session_map[uuid][:ttl]
        }
      end
    end

    # checks if a session is valid
    def is_valid?(uuid)
      expire_sessions

      begin
        session = get_session(uuid)
        return (DateTime.current <=> session[:expire]) == -1
      rescue NoSuchSessionException => e
        return false
      end
    end

    # load the session map from the database
    def load_sessions_from_database
      sessions = get_all_database_sessions
      sessions.each do |session|
        session_map[session.uuid] = {
          ttl: session.ttl_sec,
          expire: session.expire_date
        }
      end
    end

    def get_session(uuid)
      if session_map.has_key?(uuid)
        return session_map[uuid]
      end

      session = get_database_session(uuid)
      session_map[session.uuid] = {
        ttl: session.ttl_sec,
        expire: session.expire_date
      }
      return session_map[session.uuid]
    end

    def get_all_database_sessions
      Auth::ApiSession.all
    end

    def get_database_session(uuid)
      session = Auth::ApiSession.where(uuid: uuid)
      unless session.size > 0
        raise NoSuchSessionException.new("No Such Session")
      end

      return session[0]
    end

    private

    def expire_sessions
      session_map.each do |uuid, info|
        if (DateTime.current <=> info[:expire]) != -1
          begin
            get_database_session(uuid).destroy
          rescue NoSuchSessionException => e
            Rails.logger.warn("Cache is out of sync with database. uuid: #{uuid} present in cache but not db.")
          end
          session_map.delete(uuid)
        end
      end

      get_all_database_sessions.each do |db_session|
        if (DateTime.current <=> db_session.expire_date) != -1
          db_session.destroy
        end
      end
    end

  end
end