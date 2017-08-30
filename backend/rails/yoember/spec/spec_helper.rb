require 'factory_girl_rails'
require 'support/factory_girl'
require "capybara/rspec"
require 'database_cleaner'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner.logger = Rails.logger
  end

  config.before(:each) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner.logger = Rails.logger
  end

  config.before(:each, strategy: :truncation) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner.logger = Rails.logger
  end

  config.before(:each) do
    DatabaseCleaner.start
    DatabaseCleaner.logger = Rails.logger
  end

  config.after(:each) do
    DatabaseCleaner.clean
    DatabaseCleaner.logger = Rails.logger
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include FactoryGirl::Syntax::Methods
  config.include ActionDispatch::TestProcess
end
