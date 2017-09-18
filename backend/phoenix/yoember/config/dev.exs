use Mix.Config

config :yoember, YoemberWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :yoember, Yoember.Repo,
  adapter: Sqlite.Ecto2,
  database: "yoember.sqlite3",
  size: 1,
  max_overflow: 0
