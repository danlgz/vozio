defmodule VozioWeb.RoomNewLive do
  use VozioWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class={[
      "mx-auto max-w-md p-6 rounded-lg mt-20",
      "bg-vozio-surface-light dark:bg-vozio-surface-dark",
      "border border-vozio-border-light dark:border-vozio-border-dark"
    ]}>
      <.header class="text-center mb-8">
        Create a new room
        <:subtitle>
          Create a space for your team or friends to collaborate.
        </:subtitle>
      </.header>

      <.simple_form for={@form} action={~p"/room/new"} method="post">
        <.input field={@form[:name]} label="Room Name" required />
        <input type="hidden" name={@form[:created_by].name} value={@form[:created_by].value} />

        <:actions>
          <div class="flex justify-center w-full">
            <.button type="submit" phx-disable-with="Creating...">Create Room</.button>
          </div>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    form = to_form(%{"created_by" => user.id}, as: "room")
    {:ok, assign(socket, form: form)}
  end
end
