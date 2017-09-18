defmodule Yoember.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Yoember.Repo, []),
      supervisor(YoemberWeb.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: Yoember.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    YoemberWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
