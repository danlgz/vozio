defmodule VozioWeb.RoomComponents do
  use Phoenix.Component
  import VozioWeb.CoreComponents

  defp time_ago(nil), do: ""

  defp time_ago(datetime) do
    diff = DateTime.diff(DateTime.utc_now(), datetime, :second)

    cond do
      diff < 30 -> "now"
      diff < 60 -> "#{diff}s ago"
      diff < 3600 -> "#{diff}m ago"
      diff < 86400 -> "#{diff}h ago"
      diff < 2_592_000 -> "#{diff}d ago"
      diff < 31_536_000 -> "#{diff}mo ago"
      true -> "#{diff}y ago"
    end
  end

  attr :name, :string, required: true
  attr :navigate, :any, required: true
  attr :last_joined, :any, default: nil
  attr :online_users, :list, default: []

  def room_card(assigns) do
    assigns = assign(assigns, last_joined: time_ago(assigns.last_joined))

    ~H"""
    <div class={[
      "w-full border flex justify-between items-center py-4 px-6 rounded-md",
      "bg-vozio-surface-light border-vozio-border-light",
      "dark:bg-vozio-surface-dark dark:border-vozio-border-dark"
    ]}>
      <div>
        <.link navigate={@navigate}>
          <h2 class="text-lg">{@name}</h2>
        </.link>
        <div class="flex flex-col gap-1">
          <span class="text-xs">Online now</span>
          <div class="flex justify-start gap-1">
            <%= for user <- @online_users do %>
              <.tooltip text={user.name}>
                <.initial_avatar name={user.name} size="sm" color={user.color} />
              </.tooltip>
            <% end %>
          </div>
        </div>
      </div>

      <div class="flex flex-col items-end">
        <.link class="group" navigate={@navigate}>
          Join
          <.icon
            name="hero-arrow-right"
            class="h-3 w-3 group-hover:translate-x-1 transition duration-200"
          />
        </.link>
        <span class="text-xs">Last join: {@last_joined}</span>
      </div>
    </div>
    """
  end
end
