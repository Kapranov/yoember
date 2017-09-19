use Mix.Config

config :yoember,
  ecto_repos: [Yoember.Repo]

config :yoember, YoemberWeb.Endpoint,
  url: [host: System.get_env("HOSTNAME"), port: {:system, "PORT"}],
  http: [port: System.get_env("PORT") || 3000],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: YoemberWeb.ErrorView, accepts: ~w(json json-api)],
  pubsub: [name: Yoember.PubSub, adapter: Phoenix.PubSub.PG2]

config :yoember, Yoember.Repo,
  adapter: Sqlite.Ecto2,
  database: System.get_env("DB_DEV")

config :phoenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

config :cors_plug,
  origin: System.get_env("CORS_HOST"),
  max_age: 86400,
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", "HEAD"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
