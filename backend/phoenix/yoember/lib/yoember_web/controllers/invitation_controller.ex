defmodule YoemberWeb.InvitationController do
  use YoemberWeb, :controller

  alias Yoember.Invitations
  alias Yoember.Invitations.Invitation

  action_fallback YoemberWeb.FallbackController

  def index(conn, _params) do
    invitations = Invitations.list_invitations()
    render(conn, "index.json-api", data: invitations)
  end

  def create(conn, %{"invitation" => invitation_params}) do
    with {:ok, %Invitation{} = invitation} <- Invitations.create_invitation(invitation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", invitation_path(conn, :show, invitation))
      |> render("show.json-api", data: invitation)
    end
  end

  def show(conn, %{"id" => id}) do
    invitation = Invitations.get_invitation!(id)
    render(conn, "show.json-api", data: invitation)
  end

  def update(conn, %{"id" => id, "invitation" => invitation_params}) do
    invitation = Invitations.get_invitation!(id)

    with {:ok, %Invitation{} = invitation} <- Invitations.update_invitation(invitation, invitation_params) do
      render(conn, "show.json-api", data: invitation)
    end
  end

  def delete(conn, %{"id" => id}) do
    invitation = Invitations.get_invitation!(id)
    with {:ok, %Invitation{}} <- Invitations.delete_invitation(invitation) do
      send_resp(conn, :no_content, "")
    end
  end
end
