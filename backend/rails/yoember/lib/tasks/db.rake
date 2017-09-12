require 'database_cleaner'

namespace :db do
  desc 'deletes all data in all tables'
  task empty: :environment do
    DatabaseCleaner.strategy = :truncation, {except: %w[public.schema_migrations]}
    DatabaseCleaner.clean
  end
end
