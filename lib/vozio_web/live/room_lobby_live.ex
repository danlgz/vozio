defmodule VozioWeb.RoomLobbyLive do
  use VozioWeb, :live_view

  alias Vozio.Rooms

  def render(assigns) do
    ~H"""
    <div class="flex justify-between mb-4 mt-8">
      <h1 class="text-xl">Recent rooms</h1>
      <.link_button navigate={~p"/room/new"}>
        New room
      </.link_button>
    </div>

    <div class="flex flex-col gap-4">
      <%= for room <- @rooms do %>
        <.room_card
          navigate={~p"/room/#{room.id}"}
          name={room.name}
          last_joined={DateTime.utc_now(:second)}
          online_users={[
            %{id: 1, name: "Alice", color: "purple"},
            %{id: 2, name: "Bob", color: "teal"},
            %{id: 3, name: "Charlie", color: "brown"}
          ]}
        />
      <% end %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    rooms = Rooms.list_rooms()
    socket = assign(socket, :rooms, rooms)

    {:ok, socket}
  end
end
