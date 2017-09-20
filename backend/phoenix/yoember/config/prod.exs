use Mix.Config

config :yoember, YoemberWeb.Endpoint,
  load_from_system_env: true,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("HOSTNAME"), port: {:system, "PORT"}],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  root: ".",
  env: System.get_env("ENV_PROD")

config :logger, level: :info

import_config "prod.secret.exs"
