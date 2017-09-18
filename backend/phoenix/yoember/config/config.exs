use Mix.Config

config :yoember,
  ecto_repos: [Yoember.Repo]

config :yoember, YoemberWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "itDea4kx2sDQSoF1aipIb9KpBbIBg4LDpWSjTh84XuWhNH27DWgDLKIY7HxtaEY7",
  render_errors: [view: YoemberWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Yoember.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :yoember, Yoember.Repo,
  adapter: Sqlite.Ecto2,
  database: "yoember.sqlite3"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
