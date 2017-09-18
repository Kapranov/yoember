defmodule Yoember.Repo.Migrations.CreateInvitations do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :email, :string

      timestamps()
    end

  end
end
