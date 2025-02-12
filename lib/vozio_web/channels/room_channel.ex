defmodule VozioWeb.RoomChannel do
  require Logger
  use VozioWeb, :channel

  @impl true
  def join("room:" <> room_id, _payload, socket) do
    Logger.info("User joined to room: #{room_id}")
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", _payload, socket) do
    {:reply, "pong", socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_in("offer", %{"sdp" => sdp}, socket) do
    Logger.info("Offer received: #{inspect(sdp)}")

    push(socket, "offer_ack", %{status: "received"})
    {:noreply, socket}
  end

  def handle_in("candidate", %{"ice" => ice}, socket) do
    Logger.info("Candidate received: #{inspect(ice)}")
    {:noreply, socket}
  end
end
