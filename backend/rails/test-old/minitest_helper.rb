ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require "active_support/testing/setup_and_teardown"
require 'factory_girl'
require "rack/test"

FactoryGirl.find_definitions

class MiniTest::Spec
  include Rails.application.routes.url_helpers
  include Rack::Test::Methods

  def last_response_json
    JSON.parse(last_response.body)
  end
end

