defmodule VozioWeb.RoomLobbyLive do
  use VozioWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>{@message}</h1>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :message, "Bienvenido a LiveView en Homeeasdfe!")}
  end
end
