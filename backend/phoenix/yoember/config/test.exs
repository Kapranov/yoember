use Mix.Config

config :yoember, YoemberWeb.Endpoint,
  http: [port: System.get_env("TEST_PORT")],
  server: false

config :yoember, :ecto_adapter, Sqlite.Ecto2

config :yoember, Yoember.Repo,
  adapter: Application.get_env(:yoember, :ecto_adapter),
  database: System.get_env("DB_TEST"),
  pool: Ecto.Adapters.SQL.Sandbox,
  size: 1,
  max_overflow: 0

config :logger, level: :warn
