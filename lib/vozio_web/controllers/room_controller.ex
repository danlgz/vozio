defmodule VozioWeb.RoomController do
  use VozioWeb, :controller

  alias Vozio.Rooms

  def new_room(conn, %{"room" => room_params} = params) do
    IO.puts("data ->> #{inspect(params)}")

    case Rooms.create_room(room_params) do
      {:ok, room} ->
        redirect(conn, to: ~p"/room/#{room.id}")

      {:error, _room} ->
        conn
        |> put_flash(:error, "Invalid room creation, check the information and try again.")
        |> put_flash(:name, Map.get(room_params, "name", ""))
        |> redirect(to: ~p"/room/new")
    end
  end
end
