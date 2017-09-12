Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.log_level = :info
  config.consider_all_requests_local = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  config.middleware.use Rack::Throttle::Interval, :min => 3.0, :cache => Redis.new, :key_prefix => :throttle
  config.middleware.use Rack::Throttle::Interval
end

Rails.application.routes.default_url_options = {
  host: Rails.application.secrets.domain_name,
  port: Rails.application.secrets.port
}
