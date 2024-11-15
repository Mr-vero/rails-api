require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "importmap-rails"

module RailsApi
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true
    config.autoload_paths << Rails.root.join("lib")
  end
end
