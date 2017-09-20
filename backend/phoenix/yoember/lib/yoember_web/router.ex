defmodule YoemberWeb.Router do
  use YoemberWeb, :router
  use JaSerializer.PhoenixView

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
