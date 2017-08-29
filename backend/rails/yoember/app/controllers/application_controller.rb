class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::StrongParameters
  include ActionController::Serialization
  include AbstractController::Callbacks

  before_action :set_default_format
  after_action  :set_online

  def meta
    { copyright: " © #{Time.now.year} LugaTeX - #{Rails.env.upcase} Project Public License (LPPL)." }
  end

  def default_meta
    { licence: 'CC-0', authors: ['LugaTeX Inc.'] }
  end

  def json_for(target, options = {})
    options[:scope] ||= self
    options[:url_options] ||= url_options
    data = ActiveModelSerializers::SerializableResource.new(target, options)
  end

  private

  def set_online
    $redis.set("hello", "Application was connected to Redis!")
  end

  def set_default_format
    request.format = :json
  end

  def render_error(resource, status)
    render json: resource, status: status, adapter: :json_api, serializer: ErrorSerializer
  end
end
