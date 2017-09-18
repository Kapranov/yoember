use Mix.Config

config :yoember, YoemberWeb.Endpoint,
  secret_key_base:

config :yoember, Yoember.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "yoember_prod",
  pool_size: 15
