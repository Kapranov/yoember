use Mix.Config

config :yoember, YoemberWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE_PROD")

config :yoember, Yoember.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "yoember_prod",
  pool_size: 15
