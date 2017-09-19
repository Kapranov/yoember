defmodule YoemberWeb.InvitationView do
  use YoemberWeb, :view
  use JaSerializer.PhoenixView
  alias YoemberWeb.InvitationView

  attributes [:id, :email]

  def render("index.json", %{invitations: invitations}) do
    %{data: render_many(invitations, InvitationView, "invitation.json")}
  end

  def render("show.json", %{invitation: invitation}) do
    %{data: render_one(invitation, InvitationView, "invitation.json")}
  end

  def render("invitation.json", %{invitation: invitation}) do
    %{id: invitation.id,
      email: invitation.email}
  end
end
