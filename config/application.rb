require_relative 'boot'
require_relative '../lib/app_proxy'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cloudos
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # allow requests to cloudos.ca domain
    config.hosts << /.*cloudos\.ca/

    # autoload lib dir
    config.eager_load_paths << Rails.root.join('lib')

    # use custom proxy middleware
    config.middleware.use AppProxy

    # active record update time / created time, time zone
    config.active_record.default_timezone = :utc
    config.time_zone = 'UTC'

    # default settings
    config.settings = {
      # ActionJob settings
      jobs: {
        # The frequency with with the session cache is written to the database
        CACHE_SYNC_INTERVAL: 600 # 10 minutes
      },

      # application proxy settings
      proxy: {
        # start of app port range, inclusive
        app_port_start: 4000,
        # end of app port range, inclusive
        app_port_end: 4128,
        # reserved path for cloudos use
        reserved_path: '/cloudos/'
      },

      api: {
        # by default whitelist all private networks outlined in
        # https://tools.ietf.org/html/rfc1918
        ip_white_list: %w(172.17.* 192.168.* 10.0.*)
      }
    }

  end
end