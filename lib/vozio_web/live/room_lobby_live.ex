defmodule VozioWeb.RoomLobbyLive do
  use VozioWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1 class="text-2xl text-center mb-8">Recent rooms</h1>
    <div class="flex justify-end mb-4 mt-8">
      <.link_button navigate={~p"/room/new"}>
        New room
      </.link_button>
    </div>
    <div class={[
      "w-full border flex justify-between items-center py-4 px-6 rounded-md",
      "bg-vozio-surface-light border-vozio-border-light"
    ]}>
      <div>
        <.link>
          <h2 class="text-lg">Shedario Brainstorm</h2>
        </.link>
        <div class="flex flex-col gap-1">
          <span class="text-xs">Online now</span>
          <div class="flex justify-start gap-1">
            <.tooltip text="danlgz">
              <div class="w-5 h-5 rounded-full bg-vozio-primary flex justify-center items-center text-vozio-text-dark text-xs cursor-default">
                d
              </div>
            </.tooltip>
            <div class="w-5 h-5 rounded-full bg-vozio-color-green-light flex justify-center items-center text-vozio-text-dark text-xs">
              7
            </div>
            <div class="w-5 h-5 rounded-full bg-vozio-color-brown-light flex justify-center items-center text-vozio-text-dark text-xs">
              c
            </div>
          </div>
        </div>
      </div>

      <div class="flex flex-col items-end">
        <.link class="group">
          Join
          <.icon
            name="hero-arrow-right"
            class="h-3 w-3 group-hover:translate-x-1 transition duration-200"
          />
        </.link>
        <span class="text-xs">Last join: 3m ago</span>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
