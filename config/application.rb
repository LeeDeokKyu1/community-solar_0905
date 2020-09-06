require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CommunitySolar
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.i18n.default_locale = :ko
    config.i18n.fallbacks =[:en]

    config.x = Hashie::Mash.new(Rails.application.config_for(:custom))

    config.hosts << "discoverone.com"

    config.eager_load_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('app', 'services')
    config.eager_load_paths << Rails.root.join('app', 'params')

    config.paths['config/routes.rb'].concat Dir[Rails.root.join('config/routes/*.rb')]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
