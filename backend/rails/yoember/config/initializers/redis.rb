$redis = Redis::Namespace.new(Rails.application.secrets.redis_data, :redis => Redis.new, :driver => :synchrony)
