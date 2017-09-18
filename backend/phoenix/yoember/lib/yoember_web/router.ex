defmodule YoemberWeb.Router do
  use YoemberWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", YoemberWeb do
    pipe_through :api
  end
end
