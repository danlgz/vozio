defmodule Vozio.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :name, :string
    field :canvas, :map
    field :created_by, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :canvas, :created_by])
    |> validate_required([:name, :created_by])
  end
end
