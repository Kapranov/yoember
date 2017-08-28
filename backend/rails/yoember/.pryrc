if Rails.env.development? || Rails.env.test?
  extend Hirb::Console
end
