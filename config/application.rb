require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_dispatch/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SeBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # API-only mode — no HTML views, no cookies, no sessions.
    config.api_only = true

    # Autoload app/lib so JsonWebToken is available without explicit require.
    config.autoload_paths += [Rails.root.join("app", "lib")]

    # Default time zone.
    config.time_zone = "UTC"

    # Log level override via ENV.
    config.log_level = ENV.fetch("LOG_LEVEL", "info").to_sym

    # Do not generate system test files.
    config.generators.system_tests = nil
  end
end
