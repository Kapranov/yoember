defmodule Yoember.Libraries.Library do
  use Ecto.Schema
  import Ecto.Changeset
  alias Yoember.Libraries.Library

  schema "libraries" do
    field :address, :string
    field :name, :string
    field :phone, :string

    timestamps()
  end

  @doc false
  def changeset(%Library{} = library, attrs) do
    library
    |> cast(attrs, [:name, :address, :phone])
    |> validate_required([:name, :address, :phone])
  end
end
