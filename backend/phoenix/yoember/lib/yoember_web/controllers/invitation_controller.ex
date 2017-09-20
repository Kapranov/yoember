defmodule YoemberWeb.InvitationController do
  use YoemberWeb, :controller

  alias Yoember.Repo
  alias Yoember.Invitations.Invitation

  action_fallback YoemberWeb.FallbackController

  def index(conn, _params) do
    meta_default = %{
      "copyright" => "LugaTeX - Project Public License (LPPL).",
      "licence" => "CC-0"
    }
    invitations = Repo.all(Invitation)
    render(conn, "index.json-api", data: invitations, opts: [meta: meta_default])
  end

  def create(conn, %{"data" => data}) do
    meta_data = %{
      "licence" => "CC-0",
      "authors" => "LugaTeX Inc."
    }
    attrs = JaSerializer.Params.to_attributes(data)
    changeset = Invitation.changeset(%Invitation{}, attrs)
    case Repo.insert(changeset) do
      {:ok, invitation} ->
        conn
        |> put_status(201)
        |> render("show.json-api", data: invitation, opts: [meta: meta_data])
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
    invitation = Repo.get!(Invitation, id)
    render(conn, "show.json-api", data: invitation, opts: [meta: meta_default])
  end

  def update(conn, %{"id" => id, "data" => data}) do
    meta_data = %{
      "licence" => "CC-0",
      "authors" => "LugaTeX Inc."
    }
    attrs = JaSerializer.Params.to_attributes(data)
    invitation = Repo.get!(Invitation, id)
    changeset = Invitation.changeset(invitation, attrs)

    case Repo.update(changeset) do
      {:ok, invitation} ->
        render(conn, "show.json-api", data: invitation, opts: [meta: meta_data])
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
