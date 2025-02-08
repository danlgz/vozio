defmodule VozioWeb.RoomLive do
  use VozioWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <h1>Room</h1>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
