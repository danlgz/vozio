defmodule Vozio.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vozio.Rooms` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        canvas: %{},
        name: "some name"
      })
      |> Vozio.Rooms.create_room()

    room
  end
end
