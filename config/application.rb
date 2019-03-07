require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Newspaper
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.i18n.fallbacks = true
    config.time_zone = "Europe/Kiev"
    config.active_record.default_timezone = :utc
    config.encoding = "utf-8"
    #config.enable_dependency_loading = true
    #config.autoload_paths << Rails.root.join('lib')

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
