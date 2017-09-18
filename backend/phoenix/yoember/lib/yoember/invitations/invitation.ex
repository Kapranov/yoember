defmodule Yoember.Invitations.Invitation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Yoember.Invitations.Invitation


  schema "invitations" do
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(%Invitation{} = invitation, attrs) do
    invitation
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
