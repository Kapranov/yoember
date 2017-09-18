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

> To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

### 2017 September Oleg G.Kapranov

[1]: https://hexdocs.pm/phoenix/Phoenix.html
