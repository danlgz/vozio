defmodule VozioWeb.UserLoginLive do
  use VozioWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class={[
      "mx-auto max-w-md p-6 rounded-lg mt-20",
      "bg-vozio-surface-light dark:bg-vozio-surface-dark",
      "border border-vozio-border-light dark:border-vozio-border-dark"
    ]}>
      <.header class="text-center mb-8">
        Log in to account
        <:subtitle>
          Don't have an account?
          <.link
            navigate={~p"/users/register"}
            class="font-semibold text-vozio-primary hover:underline"
          >
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <div class="flex justify-center w-full">
            <.button phx-disable-with="Logging in...">
              Log in
            </.button>
          </div>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
