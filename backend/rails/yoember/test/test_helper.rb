ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/rails"
require "minitest/pride"
require "minitest/reporters"

Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(:color => true),
  Minitest::Reporters::SpecReporter.new,
  Minitest::Reporters::ProgressReporter.new,
  Minitest::Reporters::JUnitReporter.new,
  Minitest::Reporters::MeanTimeReporter.new,
  Minitest::Reporters::HtmlReporter.new
]

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || ConnectionPool::Wrapper.new(:size => 1) { retrieve_connection }
  end
end

ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

class ActiveSupport::TestCase
  fixtures :all
end
