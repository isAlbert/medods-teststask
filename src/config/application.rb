require_relative "boot"

require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module Medodstesttask
  class Application < Rails::Application
    config.load_defaults 7.0

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end


    config.after_initialize do
      require 'dry/validation'
    end

    config.autoload_paths += %W(
      #{config.root}/app/services
      #{config.root}/app/strategies
      #{config.root}/app/blueprints
      #{config.root}/app/contracts
      #{config.root}/app/lib
    )

    # log
    config.log_level = :info
    config.logger = ActiveSupport::Logger.new(STDOUT) if ENV['RAILS_LOG_TO_STDOUT'].present?

    config.exceptions_app = self.routes
    config.api_only = true
  end
end
