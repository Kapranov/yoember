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
