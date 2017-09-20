## Building APIs with Elixir/Phoenix Framework

> Software Versions

```
date -u "+%Y-%m-%d %H:%M:%S +0000"
uname -vm
mix hex.info
mix phoenix.new -v
cat mix.lock | grep distillery | cut -d" " -f 3,6 | sed 's/[",]//g'
```

> Creating the Phoenix App

We need to generate our application using Phoenix mix task without
anything except the bare minimum phoenix setup. The following command
will give you that, we do this using:

```
mix phx.new yoember --no-brunch --no-html
```

We don’t need brunch to compile assets because we have none.

> Setup database for application

Next we need to setup our database in `mix.exs` and `config/dev.exs`:

```
defp deps do
  [
    {:sqlite_ecto2, "~> 2.2", only: [:dev, :test]},
    {:faker, "~> 0.9", only: [:dev, :test]}
  ]
end
```

and we have added faker package too.

Edit the `config/config.exs`:

```
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
```

Edit the `config/dev.exs`:

```
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
```

Edit the `config/test.exs`:

```
use Mix.Config

config :yoember, YoemberWeb.Endpoint,
  http: [port: System.get_env("TEST_PORT")],
  server: false,
  env: System.get_env("ENV_TEST")

config :yoember, :ecto_adapter, Sqlite.Ecto2

config :yoember, Yoember.Repo,
  adapter: Application.get_env(:yoember, :ecto_adapter),
  database: System.get_env("DB_TEST"),
  pool: Ecto.Adapters.SQL.Sandbox,
  size: 1,
  max_overflow: 0

config :logger, level: :warn
```

Edit the `config/prod.exs`:

```
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
```

Edit the `Yoember.Repo` module in `lib/yoember/repo.ex` to use the
`sqlite_ecto2` adapter:

```
defmodule Yoember.Repo do
  use Ecto.Repo, otp_app: :yoember, adapter: Application.get_env(:yoember, :ecto_adapter)

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
```

> Environment Variable Definitions

```
# create file .env
touch .env

# file .env:
export PORT="3000"
export CORS_HOST="api.dev.local:4200"
export TEST_PORT="4000"
export HOSTNAME="api.dev.local"
export DB_DEV="yoember.sqlite3"
export DB_PROD="yoember.sqlite3"
export DB_TEST="test/yoember.sqlite3"
export ENV_DEV="Development"
export ENV_TEST="Test"
export ENV_PROD="Production"
export SECRET_KEY_BASE="op4XPX42oJ6AHp8zpPSFMhmoqmsbjg799/5JM8oU2jeGiwXn/JQsHC/prYuuVJuG",
export SECRET_KEY_BASE_PROD="jmakITT6898HnS2/cwS0JKErDy945gXMQmjTMcAteVkSQcID3WBUkrMfHk1XLqOT"
```

> Start Up App in development and test an enviroments

```
source .env

mix deps.get
mix deps.clean --all
mix deps.get
mix deps.update --all
mix deps.get

mix ecto.create
mix ecto.migrate

mix run priv/repo/seeds.exs

mix test
```

> Creating the models

```
mix phx.gen.json Invitations Invitation invitations email:string
mix phx.gen.json Libraries Library libraries name:string address:string phone:string
```
edit router `lib/yoember_web/router.ex`:

```
defmodule YoemberWeb.Router do
  use YoemberWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", YoemberWeb do
    pipe_through :api

    get "/", LibraryController, :index

    resources "/invitations", InvitationController, except: [:new, :edit]
    resources "/libraries", LibraryController, except: [:new, :edit]
  end
end
```

check out routers: `mix phx.routes`:

```
   library_path  GET     /                 YoemberWeb.LibraryController :index
invitation_path  GET     /invitations      YoemberWeb.InvitationController :index
invitation_path  GET     /invitations/:id  YoemberWeb.InvitationController :show
invitation_path  POST    /invitations      YoemberWeb.InvitationController :create
invitation_path  PATCH   /invitations/:id  YoemberWeb.InvitationController :update
                 PUT     /invitations/:id  YoemberWeb.InvitationController :update
invitation_path  DELETE  /invitations/:id  YoemberWeb.InvitationController :delete
   library_path  GET     /libraries        YoemberWeb.LibraryController :index
   library_path  GET     /libraries/:id    YoemberWeb.LibraryController :show
   library_path  POST    /libraries        YoemberWeb.LibraryController :create
   library_path  PATCH   /libraries/:id    YoemberWeb.LibraryController :update
                 PUT     /libraries/:id    YoemberWeb.LibraryController :update
   library_path  DELETE  /libraries/:id    YoemberWeb.LibraryController :delete

```

Run migrations: `mix ecto.migrate`

Create fakers data `priv/repo/seeds.exs`:

```
alias Yoember.Repo
alias Yoember.Invitations.Invitation
alias Yoember.Libraries.Library
alias Faker, as: Faker

for _ <- 1..9 do
  Repo.insert!(%Invitation{
    email: Faker.Internet.free_email
  })
  Repo.insert!(%Library{
    name: Faker.Name.name,
    address: Enum.join([Faker.Address.street_address(true), " ", Faker.Address.city]),
    phone: Faker.Phone.EnUs.extension(10)
  })
end
```

Run faker seeds: `mix run priv/repo/seeds.exs`

Check out resources: `mix phx.server`

> Setting JSONAPI format and Serialization

I’ll be following [jsonapi][3] format for building out the APIs. It’s
really scalable and obviously, you should be following some standards
while designing your APIs.

Poison is a new JSON library for Elixir focusing on wicked-fast speed
without sacrificing simplicity, completeness, or correctness and takes
several approaches to be the fastest JSON library for Elixir. It will
add `poison` to `mix.exs`:

```
defp deps do
  [
    {:timex, "~> 3.1"},
    {:plug, "~> 1.4"},
    {:mime, "~> 1.1"},
    {:poison, "~> 3.1"},
    {:ja_serializer, "~> 0.12"},
    {:cors_plug, "~> 1.4"}
  ]
end
```

We’ll need to make some minor changes so that our app follows this spec.
Open `config/config.exs` and add the following code:

```
config :yoember, YoemberWeb.Endpoint,
  render_errors: [view: YoemberWeb.ErrorView, accepts: ~w(json json-api)],

config :phoenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}
```

By default, jsonapi specs require the mime type to be:

```
application/vnd.api+json
```
We'll add `JaSerializer` to `lib/yoember_web/router.ex`:

```
defmodule YoemberWeb.Router do
  use YoemberWeb, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/", YoemberWeb do
    pipe_through :api

    get "/", LibraryController, :index

    resources "/invitations", InvitationController, except: [:new, :edit]
    resources "/libraries", LibraryController, except: [:new, :edit]
  end
end
```

and add to `lib/yoember_web/views/invitation_view.ex`:

```
defmodule YoemberWeb.InvitationView do
  use YoemberWeb, :view
  use JaSerializer.PhoenixView
  alias YoemberWeb.InvitationView

  attributes [:id, :email]

  def render("index.json", %{invitations: invitations}) do
    %{data: render_many(invitations, InvitationView, "invitation.json")}
  end

  def render("show.json", %{invitation: invitation}) do
    %{data: render_one(invitation, InvitationView, "invitation.json")}
  end

  def render("invitation.json", %{invitation: invitation}) do
    %{id: invitation.id,
      email: invitation.email}
  end
end
```

and to `lib/yoember_web/views/library_controller.ex`:

```
defmodule YoemberWeb.LibraryView do
  use YoemberWeb, :view
  use JaSerializer.PhoenixView
  alias YoemberWeb.LibraryView

  attributes [:id, :name, :address, :phone]

  def render("index.json", %{libraries: libraries}) do
    %{data: render_many(libraries, LibraryView, "library.json")}
  end

  def render("show.json", %{library: library}) do
    %{data: render_one(library, LibraryView, "library.json")}
  end

  def render("library.json", %{library: library}) do
    %{id: library.id,
      name: library.name,
      address: library.address,
      phone: library.phone}
  end
end
```

Update controller to 'lib/controllers/invitation_controller.ex':

```
defmodule YoemberWeb.InvitationController do
  use YoemberWeb, :controller

  alias Yoember.Repo
  alias Yoember.Invitations.Invitation

  action_fallback YoemberWeb.FallbackController

  def index(conn, _params) do
    invitations = Repo.all(Invitation)
    render(conn, "index.json-api", data: invitations)
  end

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    changeset = Invitation.changeset(%Invitation{}, attrs)
    case Repo.insert(changeset) do
      {:ok, invitation} ->
        conn
        |> put_status(201)
        |> render("show.json-api", data: invitation)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(:errors, data: changeset)
    end
  end


  def show(conn, %{"id" => id}) do
    invitation = Repo.get!(Invitation, id)
    render(conn, "show.json-api", data: invitation)
  end

  def update(conn, %{"id" => id, "data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    invitation = Repo.get!(Invitation, id)
    changeset = Invitation.changeset(invitation, attrs)

    case Repo.update(changeset) do
      {:ok, invitation} ->
        render(conn, "show.json-api", data: invitation)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
     invitation = Repo.get!(Invitation, id)
     Repo.delete!(invitation)
     send_resp(conn, :no_content, "")
  end
end
```

and `lib/controllers/library_controller.ex`:

```
defmodule YoemberWeb.LibraryController do
  use YoemberWeb, :controller

  alias Yoember.Repo
  alias Yoember.Libraries.Library

  action_fallback YoemberWeb.FallbackController

  def index(conn, _params) do
    libraries = Repo.all(Library)
    render(conn, "index.json-api", data: libraries)
  end

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    changeset = Library.changeset(%Library{}, attrs)
    case Repo.insert(changeset) do
      {:ok, library} ->
        conn
        |> put_status(201)
        |> render("show.json-api", data: library)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    library = Repo.get!(Library, id)
    render(conn, "show.json-api", data: library)
  end

  def update(conn, %{"id" => id, "data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    library = Repo.get!(Library, id)
    changeset = Library.changeset(library, attrs)

    case Repo.update(changeset) do
      {:ok, library} ->
        render(conn, "show.json-api", data: library)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
     library = Repo.get!(Library, id)
     Repo.delete!(library)
     send_resp(conn, :no_content, "")
  end
end
```

**Setting up CORS**

Also, since our APIs will be consumed by a frontend app which will
reside in some other domain, we’ll need to add CORS support for our
backend app.

We’ll have to add `cors_plug` to our list of dependencies in `mix.exs`
which will look like this, we had been done early:

add to `lib/yoember_web/endpoint.ex`:

```
  plug CORSPlug
  plug YoemberWeb.Router
```

And also you can put configuration into `config/config.exs`:

```
config :cors_plug,
  origin: System.get_env("CORS_HOST"),
  max_age: 86400,
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", "HEAD"]
```
Update errors view `lib/yoember_web/views/error_view.ex`:

```
defmodule YoemberWeb.ErrorView do
  use YoemberWeb, :view

  def render("401.json", _assigns) do
    %{
      errors: %{message: "Unauthorized"},
      meta: %{licence: "CC-0", authors: "LugaTeX Inc."}
    }
  end

  def render("403.json", _assigns) do
    %{
      errors: %{message: "Forbidden"},
      meta: %{licence: "CC-0", authors: "LugaTeX Inc."}
    }
  end

  def render("404.json", _assigns) do
    %{
      errors: %{message: "Page not found"},
      meta: %{licence: "CC-0", authors: "LugaTeX Inc."}
    }
  end

  def render("422.json", _assigns) do
    %{
      errors: %{message: "Unprocessable entity"},
      meta: %{licence: "CC-0", authors: "LugaTeX Inc."}
    }
  end

  def render("500.json", _assigns) do
    %{
      errors: %{message: "Server Error"},
      meta: %{licence: "CC-0", authors: "LugaTeX Inc."}
    }
  end

  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
```

Clean up `lib/yoember_web/endpoint.ex`:

```
defmodule YoemberWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :yoember

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_yoember_key",
    signing_salt: "5PI7nd6V"

  plug CORSPlug

  plug YoemberWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
```

Remove sockets `rm -r lib/yoember_web/channels/`.

For now, the initial step to bootstrap our app is complete.

Start servers backend(Phoenix), front-end(Ember) for check out all of
them: `mix phx.server` vs `ember server`.

> Testing

> Pagination

> iex console

```
import Ecto.Query

query = from w in Yoember.Libraries.Library, where: w.id == 1
Yoember.Repo.all(query)

Yoember.Repo.all(Yoember.Libraries.Library |> select([library], library.name))
```

> To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server` or interactive `iex -S mix`

Now you can visit [`localhost:4000`](http://localhost:3000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

> Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

### 2017 September Oleg G.Kapranov

[1]: https://hex.pm/
[2]: https://hexdocs.pm/phoenix/Phoenix.html
[3]: http://jsonapi.org/
[4]: https://github.com/vt-elixir/ja_serializer
[5]: https://github.com/drewolson/scrivener
[5]: https://github.com/phoenixframework/phoenix_pubsub_redis
[6]: https://github.com/igrs/phoenix_session_redis
[7]: https://github.com/aposto/plug_session_redis
[8]: https://github.com/artemeff/exredis
[9]: https://github.com/aposto/plug_session_redis
[10]: https://github.com/thoughtbot/redbird
[11]: https://github.com/ianwalter/bouncer
[12]: https://github.com/whatyouhide/redix
