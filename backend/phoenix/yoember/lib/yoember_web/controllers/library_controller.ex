defmodule YoemberWeb.LibraryController do
  use YoemberWeb, :controller

  alias Yoember.Libraries
  alias Yoember.Libraries.Library

  action_fallback YoemberWeb.FallbackController

  def index(conn, _params) do
    libraries = Libraries.list_libraries()
    render(conn, "index.json-api", data: libraries)
  end

  def create(conn, %{"library" => library_params}) do
    with {:ok, %Library{} = library} <- Libraries.create_library(library_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", library_path(conn, :show, library))
      |> render("show.json-api", data: library)
    end
  end

  def show(conn, %{"id" => id}) do
    library = Libraries.get_library!(id)
    render(conn, "show.json-api", data: library)
  end

  def update(conn, %{"id" => id, "library" => library_params}) do
    library = Libraries.get_library!(id)

    with {:ok, %Library{} = library} <- Libraries.update_library(library, library_params) do
      render(conn, "show.json-api", data: library)
    end
  end

  def delete(conn, %{"id" => id}) do
    library = Libraries.get_library!(id)
    with {:ok, %Library{}} <- Libraries.delete_library(library) do
      send_resp(conn, :no_content, "")
    end
  end
end
