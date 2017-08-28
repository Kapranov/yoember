ApplicationController.renderer.defaults.merge!(
  http_host: Rails.application.secrets.domain_name,
  https: false
)
