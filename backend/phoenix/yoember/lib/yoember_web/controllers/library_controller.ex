defmodule YoemberWeb.LibraryController do
  use YoemberWeb, :controller

  alias Yoember.Repo
  alias Yoember.Libraries.Library

  action_fallback YoemberWeb.FallbackController

  def index(conn, _params) do
    meta_default = %{
      "copyright" => "LugaTeX - Project Public License (LPPL).",
      "licence" => "CC-0"
    }
    libraries = Repo.all(Library)
    render(conn, "index.json-api", data: libraries, opts: [meta: meta_default])
  end

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    changeset = Library.changeset(%Library{}, attrs)
    meta_data = %{
      "licence" => "CC-0",
      "authors" => "LugaTeX Inc."
    }
    case Repo.insert(changeset) do
      {:ok, library} ->
        conn
        |> put_status(201)
        |> render("show.json-api", data: library, opts: [meta: meta_data])
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    meta_default = %{
      "copyright" => "LugaTeX - Project Public License (LPPL).",
      "licence" => "CC-0"
    }
    library = Repo.get!(Library, id)
    render(conn, "show.json-api", data: library, opts: [meta: meta_default])
  end

  def update(conn, %{"id" => id, "data" => data}) do
    meta_data = %{
      "licence" => "CC-0",
      "authors" => "LugaTeX Inc."
    }
    attrs = JaSerializer.Params.to_attributes(data)
    library = Repo.get!(Library, id)
    changeset = Library.changeset(library, attrs)

    case Repo.update(changeset) do
      {:ok, library} ->
        render(conn, "show.json-api", data: library, opts: [meta: meta_data])
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
