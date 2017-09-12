class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include ActionController::Serialization

  before_action :set_default_format
  before_action :check_header
  after_action  :set_online

  def json_for(target, options = {})
    options[:scope] ||= self
    options[:url_options] ||= url_options
    ActiveModelSerializers::SerializableResource.new(target, options)
  end

  private

  def set_online
    $redis.set("hello", "Application was connected to Redis!")
  end

  def set_default_format
    request.format = :json
  end

  def meta
    { copyright: " © #{Time.now.year} LugaTeX - #{Rails.env.upcase} Project Public License (LPPL).", licence: 'CC-0' }
  end

  def default_meta
    { licence: 'CC-0', authors: ['LugaTeX Inc.'] }
  end

  def check_header
    if ['POST','PUT','PATCH'].include? request.method
      if request.content_type != "application/vnd.api+json"
        head 406 and return
      end
    end
  end

  def validate_type
    if params['data'] && params['data']['type']
      if params['data']['type'] == params[:controller]
        return true
      end
    end
    head 409 and return
  end

  def render_error(resource, status)
    render json: resource, status: status, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
  end
end
