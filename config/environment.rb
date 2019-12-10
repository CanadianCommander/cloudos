# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# start system jobs
Auth::SessionCacheSyncJob.set(wait: Rails.application.config.settings[:jobs][:cache_sync_interval]).perform_later