use Mix.Config

config :yoember, YoemberWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :yoember, :ecto_adapter, Sqlite.Ecto2

config :yoember, Yoember.Repo,
  adapter: Application.get_env(:yoember, :ecto_adapter),
  database: "test/yoember.sqlite3",
  pool: Ecto.Adapters.SQL.Sandbox,
  size: 1,
  max_overflow: 0
