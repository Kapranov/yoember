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
config :rephink, Yoember.Repo,
  adapter: Sqlite.Ecto2,
  database: "yoember.sqlite3"
```

Edit the `config/dev.exs`:

```
config :yoember, Yoember.Repo,
  adapter: Sqlite.Ecto2,
  database: "yoember.sqlite3",
  size: 1,
  max_overflow: 0
```

Edit the `config/test.exs`:

```
config :yoember, :ecto_adapter, Sqlite.Ecto2

config :yoember, Yoember.Repo,
  adapter: Application.get_env(:yoember, :ecto_adapter),
  database: "test/yoember.sqlite3",
  pool: Ecto.Adapters.SQL.Sandbox,
  size: 1,
  max_overflow: 0
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
export DB_DEV="yoember.sqlite3"
export DB_PROD="yoember.sqlite3"
export DB_TEST="test/yoember.sqlite3"
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

> To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

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
