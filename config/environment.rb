# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# start system jobs
Auth::SessionCacheSyncJob.set(wait: 60).perform_later