use Mix.Config

config :yoember, YoemberWeb.Endpoint,
  http: [ip: {127,0,0,1}, port: System.get_env("PORT") || 3000],
  url: [host: System.get_env("HOSTNAME"), port: {:system, "PORT"}],
  debug_errors: false,
  catch_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [],
  server: true,
  env: System.get_env("ENV_DEV")

config :yoember, Yoember.Repo,
  adapter: Sqlite.Ecto2,
  database: System.get_env("DB_DEV"),
  size: 1,
  max_overflow: 0

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20
