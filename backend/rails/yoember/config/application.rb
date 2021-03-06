require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "rails/test_unit/railtie"
require "./lib/middleware/catch_json_parse_errors.rb"
require 'rack/throttle'


Bundler.require(*Rails.groups)

module Yoember
  class Application < Rails::Application
    config.load_defaults 5.1
    config.api_only = true
    config.time_zone = 'Eastern Time (US & Canada)'
    config.eager_load_paths << Rails.root.join('lib')
    config.action_controller.perform_caching = true
    config.cache_store = :redis_store, Rails.application.secrets.redis_cache, { expires_in: 90.minutes }
    config.debug_exception_response_format = :api
    config.exceptions_app = self.routes
    config.lograge.keep_original_rails_log = true
    config.lograge.logger = ActiveSupport::Logger.new "#{Rails.root}/log/#{Rails.env}_lograge.log"
    config.lograge.formatter = ->(data) { "Called #{data[:controller]}" }
    config.lograge.custom_options = lambda do |event|
      {:time => event.time, :search_engine => event.payload[:search_engine], :user_agent => event.payload[:user_agent]}
    end
    config.middleware.delete Rack::Sendfile
    config.middleware.delete Rack::Runtime
    config.middleware.insert_before Rack::Head, CatchJsonParseErrors
  end
end
